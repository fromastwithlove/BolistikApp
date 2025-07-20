//
//  AuthenticationService.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 12.03.25.
//

import Foundation
import AuthenticationServices
import FirebaseCore
@preconcurrency import FirebaseAuth
@preconcurrency import GoogleSignIn
import CryptoKit

final class AuthenticationService: AuthenticationServiceProtocol {
    
    // MARK: - Private properties
    
    private let logger = AppLogger(category: "Authentication")
    private var currentNonce: String?
    private var firestoreService: FirestoreServiceProtocol
    
    init(firestoreService: FirestoreServiceProtocol) {
        self.firestoreService = firestoreService
    }
    
    // MARK: - User Information
    
    var isAuthenticated: Bool {
        return Auth.auth().currentUser != nil
    }
    
    var userID: String? {
        return Auth.auth().currentUser?.uid
    }
    
    // MARK: - Account Verification
    
    func verifyAuthenticationState() async throws {
        logger.debug("Account verification started")
        
        guard let currentUser = Auth.auth().currentUser else {
            await signOut()
            throw AuthenticationError.accountNotFound
        }
        
        for provider in currentUser.providerData {
            do {
                switch provider.providerID {
                    case "apple.com":
                        logger.debug("Apple account verification started.")
                        try await verifyAppleAccountStatus(appleProvider: provider)
                    return
                    case "google.com":
                        // FIXME: Do I need to verify the google token?
                        logger.debug("Google account verification started.")
                    return
                    default:
                        logger.debug("Unknown provider: \(provider.providerID).")
                }
            } catch {
                logger.error("Verification failed: \(error)")
            }
        }
    }
    
    @MainActor
    private func verifyAppleAccountStatus(appleProvider: UserInfo) async throws {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        do {
            let credentialState = try await appleIDProvider.credentialState(forUserID: appleProvider.uid)
            switch credentialState {
                case .authorized:
                    logger.debug("Apple account is signed in")
                    break
                case .revoked, .notFound:
                    logger.debug("Apple account is revoked or not found")
                    await signOut()
                    throw AuthenticationError.accountNotFound
                case .transferred:
                    logger.debug("Apple account is transferred")
                    throw AuthenticationError.accountTransferred
                default:
                    throw AuthenticationError.serverError
            }
        } catch {
            throw error
        }
    }
    
    // MARK: - Apple Sign-In
    
    func prepareAppleSignIn(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email];
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    func handleSignInWithApple(result: Result<ASAuthorization, Error>) async throws {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    logger.error("Error a login callback received without a nonce")
                    throw AuthenticationError.missingNonce
                }
                
                guard let token = appleIDCredential.identityToken,
                      let tokenString = String(data: token, encoding: .utf8) else {
                    logger.error("Missing identity token or unable to serialize it as a string")
                    throw AuthenticationError.serverError
                }

                let credential = OAuthProvider.appleCredential(withIDToken: tokenString,
                                                               rawNonce: nonce,
                                                               fullName: appleIDCredential.fullName)
                
                do {
                    let result = try await Auth.auth().signIn(with: credential)
                    Task {
                        try await createContact(firebaseUser: result.user, displayName: appleIDCredential.fullName?.formatted())
                    }
                } catch {
                    logger.error("Signing in with Firebase using Apple ID is failed with error: \(error)")
                    throw AuthenticationError.serverError
                }
            }
        case .failure(let error):
            logger.error("Error signing in with Apple", metadata: ["Error": error.localizedDescription])
            throw error
        }
    }
    
    // MARK: - Google Sign-In
    
    func handleSignInWithGoogle() async throws {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw AuthenticationError.missingGoogleClientID
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            logger.error("There is no window or root view controller")
            return
        }

        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = userAuthentication.user
            
            guard let idToken = user.idToken else {
                throw AuthenticationError.googleIDTokenIsMissing
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: user.accessToken.tokenString)
            let result = try await Auth.auth().signIn(with: credential)
            Task {
                try await createContact(firebaseUser: result.user, displayName: result.user.displayName)
            }
        } catch {
            logger.error("Login failed with Google account: \(error)")
            throw error
        }
    }
    
    // MARK: - Firestore Account Creation
    
    private func createContact(firebaseUser: User, displayName: String?) async throws {
        
        // FIXME: It doesn't fetch the request if there is not "contacts" collection.
        let contactExists = try await firestoreService.contactExists(id: firebaseUser.uid)
        
        // Contact already exists, no need to create a new one
        if contactExists { return }
        
        // Extract full name from displayName if available
        let fullName = displayName.flatMap {
            PersonNameComponentsFormatter().personNameComponents(from: $0)
        }
        
        try await firestoreService.saveContact(id: firebaseUser.uid,
                                               email: firebaseUser.email,
                                               avatarPath: nil,
                                               fullName: fullName)
    }
    
    // MARK: - Sign Out
    
    func signOut() async {
        do {
            try Auth.auth().signOut()
            logger.debug("Successfully signed out from Firebase.")
        } catch {
            logger.error("Error signing out from Firebase: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Apple and Firebase security requirements
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }

    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}
