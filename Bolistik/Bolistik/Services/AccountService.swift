//
//  AccountService.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 08.12.24.
//

import AuthenticationServices

actor AccountService {

    // MARK: Private
    
    private let logger = AppLogger(category: "Session")
    private var currentNonce: String?
    private let firebaseAuthService: FirebaseAuthService
    
    // MARK: Public
    
    init(firebaseAuthService: FirebaseAuthService) {
        self.firebaseAuthService = firebaseAuthService
        
        if let firebaseUser = firebaseAuthService.user {
            self.user = InternalUser(from: firebaseUser)
        }
    }
    
    public private(set) var user: InternalUser?
    
    public var isAuthenticated: Bool {
        get async { user != nil }
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

                let task = firebaseAuthService.signInWith(appleIDToken: tokenString, nonce: nonce, fullName: appleIDCredential.fullName)
                
                do {
                    user = try await task.value
                } catch {
                    logger.error("Signing in with Firebase is failed with error: \(error)")
                }
                
                if let fullName = appleIDCredential.fullName, !fullName.formatted().isEmpty {
                    firebaseAuthService.updateDisplayName(displayName: fullName.formatted())
                    user?.displayName = fullName.formatted()
                }
            }
        case .failure(let error):
            logger.error("Error signing in with Apple", metadata: ["Error": error.localizedDescription])
            throw error
        }
    }
    
    func signOut() async throws {
        do {
            try firebaseAuthService.signOut()
        } catch {
            throw error
        }
    }
    
    func verifyAccountStatus() async throws {
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
                break
            case .revoked, .notFound:
                logger.debug("Apple account is revoked or not found")
                do {
                    try firebaseAuthService.signOut()
                    user = nil
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
}

extension AccountService {
    /// Defines errors that may occur during authentication.
    /// Provides localized messages for user-friendly error descriptions.
    public enum AuthenticationError: LocalizedError {
        case accountNotFound
        case accountTransferred
        case serverError
        case missingNonce
        
        /// A computed property to return a localized error message for each error case.
        public var errorDescription: String? {
            switch self {
            case .accountNotFound:
                return NSLocalizedString("auth.error.message.accountNotFound", comment: "Error: Account not found")
            case .serverError:
                return NSLocalizedString("auth.error.message.serverError", comment: "Error: Server error")
            case .accountTransferred:
                return NSLocalizedString("auth.error.message.accountTransferred", comment: "Error: Account transferred")
            case .missingNonce:
                return NSLocalizedString("auth.error.message.missingNonce", comment: "Error: Missing nonce")
            }
        }
    }
}
