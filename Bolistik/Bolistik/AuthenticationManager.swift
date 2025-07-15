//
//  AuthenticationManager.swift
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

// MARK: - Authentication Error Enum

public enum AuthenticationError: LocalizedError {
    case accountNotFound
    case accountTransferred
    case serverError
    case missingNonce
    case missingGoogleClientID
    case googleIDTokenIsMissing
    case nameConversionFailed
    
    /// A computed property to return a localized error message for each error case.
    public var errorDescription: String? {
        switch self {
            case .accountNotFound:
                return NSLocalizedString("error.auth.accountNotFound", comment: "Error: Account not found")
            case .serverError:
                return NSLocalizedString("error.auth.serverError", comment: "Error: Server error")
            case .accountTransferred:
                return NSLocalizedString("error.auth.accountTransferred", comment: "Error: Account transferred")
            case .missingNonce:
                return NSLocalizedString("error.auth.missingNonce", comment: "Error: Missing nonce")
            case .missingGoogleClientID:
                return NSLocalizedString("error.auth.missingGoogleClientID", comment: "Error: Missing Google client ID")
            case .googleIDTokenIsMissing:
                return NSLocalizedString("error.auth.googleIDTokenIsMissing", comment: "Error: Missing Google ID token")
            case .nameConversionFailed:
                return NSLocalizedString("error.auth.nameConversionFailed", comment: "Error: Failed to convert display name to full name")
            
        }
    }
}

@MainActor
@Observable
final class AuthenticationManager: ObservableObject {
    
    // MARK: - Private properties
    
    private let logger = AppLogger(category: "Authentication")
    private var currentNonce: String?
    private var firestoreService: FirestoreServiceProtocol
    
    init(firestoreService: FirestoreServiceProtocol) {
        self.firestoreService = firestoreService
    }
    
    // MARK: - User Information
     
    public var user: User? {
        return Auth.auth().currentUser
    }
    
    public var isAuthenticated: Bool {
        return Auth.auth().currentUser != nil
    }
    
    // MARK: - Sign-Out
    
    public func signOut() async {
        do {
            try Auth.auth().signOut()
            logger.debug("Successfully signed out from Firebase.")
        } catch {
            logger.error("Error signing out from Firebase: \(error.localizedDescription)")
        }
    }
}

// MARK: - Authentication Verification

extension AuthenticationManager {
     
    public func verifyAuthenticationState() async throws {
        logger.debug("Account verification started")
        
        guard let currentUser = user else {
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
}

// MARK: - Apple Sign-In

extension AuthenticationManager {
    
    public func prepareAppleSignIn(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email];
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    public func handleSignInWithApple(result: Result<ASAuthorization, Error>) async throws {
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
                    try await createUserProfile(firebaseUser: result.user, displayName: appleIDCredential.fullName?.formatted())
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
    
    private func createUserProfile(firebaseUser: User, displayName: String?) async throws {
        let userProfileExists = try await firestoreService.profileExists(id: firebaseUser.uid)
        
        // Profile already exists, no need to create a new one
        if userProfileExists { return }
        
        // Extract full name from displayName if available
        let fullName = displayName.flatMap {
            PersonNameComponentsFormatter().personNameComponents(from: $0)
        }
        
        try await firestoreService.saveProfile(id: firebaseUser.uid,
                                               email: firebaseUser.email,
                                               avatarPath: nil,
                                               fullName: fullName)
    }
}

// MARK: - Google Sign-In

extension AuthenticationManager {
    
    public func handleSignInWithGoogle() async throws {
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
            try await createUserProfile(firebaseUser: result.user, displayName: result.user.displayName)
        } catch {
            logger.error("Login failed with Google account: \(error)")
            throw error
        }
    }
}

// MARK: - Apple and Firebase security requirements

extension AuthenticationManager {
    
    public func randomNonceString(length: Int = 32) -> String {
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

    public func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}
