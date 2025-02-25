//
//  AuthenticationService.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 08.12.24.
//

import AuthenticationServices

// MARK: - Authentication Error Enum

public enum AuthenticationError: LocalizedError {
    case accountNotFound
    case accountTransferred
    case serverError
    case missingNonce
    
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
        }
    }
}

// MARK: - Authentication Service

actor AuthenticationService {

    // MARK: Private Properties and Methods
    
    private let logger = AppLogger(category: "Authentication")
    private var currentNonce: String?
    private let firebaseAuthService: FirebaseAuthService
    private let firestoreService: FirestoreService
    
    private func setUserProfileWith(fullName: PersonNameComponents?) async throws {
        guard let firebaseUser = firebaseAuthService.user, let email = firebaseUser.email else {
            logger.error("No Firebase user available or email doesn't exist")
            return
        }
        
        do {
            // Fetch the user profile from Firestore if it exists
            if let existingUserProfile: UserProfile = try await firestoreService.fetch(firebaseUser.uid, fromCollection: FirestoreCollections.userProfiles) {
                userProfile = existingUserProfile
                logger.debug("User profile already exists in Firestore: \(existingUserProfile.uid), skipping save")
                return
            } else {
                // If the profile doesn't exist, create and save a new profile
                logger.debug("No user profile found in Firestore, creating a new one for UID: \(firebaseUser.uid)")
                
                if let fullName = fullName, !fullName.formatted().isEmpty {
                    let newUserProfile = UserProfile(uid: firebaseUser.uid, email: email, fullName: fullName)
                    userProfile = newUserProfile
                    
                    try await firestoreService.save(newUserProfile, inCollection: FirestoreCollections.userProfiles, withDocumentId: newUserProfile.uid)
                    logger.debug("User profile \(newUserProfile.uid) saved successfully in Firestore")       
                }
            }
        } catch {
            logger.error("Failed to fetch or save user profile: \(error)")
        }
    }
    
    // MARK: Public Properties and Methods
    
    init(firebaseAuthService: FirebaseAuthService, firestoreService: FirestoreService) {
        self.firebaseAuthService = firebaseAuthService
        self.firestoreService = firestoreService
    }
    
    public private(set) var userProfile: UserProfile?
    
    public var isAuthenticated: Bool {
        get async { firebaseAuthService.user != nil }
    }
    
    // MARK: Sign in with Apple
    
    public func prepareAppleSignIn(request: ASAuthorizationAppleIDRequest) async {
        let nonce = firebaseAuthService.randomNonceString()
        currentNonce = nonce
        request.nonce = firebaseAuthService.sha256(nonce)
    }
    
    public func handleSignInWithApple(result: Result<ASAuthorization, any Error>) async throws {
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

                let firebaseSignInTask = firebaseAuthService.signInWith(appleIDToken: tokenString, nonce: nonce, fullName: appleIDCredential.fullName)
                
                do {
                    try await firebaseSignInTask.value
                    try await setUserProfileWith(fullName: appleIDCredential.fullName)
                } catch {
                    logger.error("Signing in with Firebase is failed with error: \(error)")
                }
            }
        case .failure(let error):
            logger.error("Error signing in with Apple", metadata: ["Error": error.localizedDescription])
            throw error
        }
    }
    
    public func verifyAccountStatus() async throws {
        logger.debug("Apple account verification started")
        
        guard let currentUserID = firebaseAuthService.appleUserUID() else {
            logger.debug("Apple account is not found")
            return
        }
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        // TODO: Perform check if it is the apple provider
        do {
            let credentialState = try await appleIDProvider.credentialState(forUserID: currentUserID)
            switch credentialState {
            case .authorized:
                logger.debug("Apple account is signed in")
                do {
                    try await setUserProfileWith(fullName: nil)
                } catch {
                    throw error
                }
                break
            case .revoked, .notFound:
                logger.debug("Apple account is revoked or not found")
                do {
                    try firebaseAuthService.signOut()
                } catch {
                    throw AuthenticationError.serverError
                }
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
    
    // MARK: - Sign Out
    
    public func signOut() async throws {
        do {
            try firebaseAuthService.signOut()
        } catch {
            throw error
        }
    }
}
