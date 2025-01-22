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
    private var authenticationState: AuthenticationState = .unknown
    private let userDefaults = UserDefaults()
    
    // MARK: Public
    
    public var isAuthenticated: Bool {
        get async { authenticationState == .signedIn }
    }
    
    public var fullName: PersonNameComponents? {
        get async { userDefaults.fullName }
    }
    
    public var email: String? {
        get async { userDefaults.email }
    }
    
    private(set) var identityToken: String?
    private(set) var authorizationCode: String?
    
    func verifyAccountStatus() async throws {
        logger.debug("Apple account verification started")
        guard let currentUserID = userDefaults.token else {
            authenticationState = .unknown
            logger.debug("Apple account is not found")
            return
        }

        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        do {
            let credentialState = try await appleIDProvider.credentialState(forUserID: currentUserID)
            switch credentialState {
            case .authorized:
                logger.debug("Apple account is signed in")
                authenticationState = .signedIn
            case .revoked, .notFound:
                logger.debug("Apple account is revoked or not found")
                authenticationState = .unknown
                userDefaults.clearToken()
                throw AuthenticationError.accountNotFound
            case .transferred:
                authenticationState = .signedOut
                logger.debug("Apple account is signed out")
                throw AuthenticationError.accountTransferred
            default:
                logger.debug("Apple account state is unknown")
                authenticationState = .unknown
                throw AuthenticationError.serverError
            }
        } catch {
            throw error
        }
    }
    
    func signInWithApple(result: Result<ASAuthorization, any Error>) async throws -> Bool {
        switch result {
        case .success(let authorization):
            if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
                userDefaults.token = credential.user
                if let fullName = credential.fullName,
                   let givenName = fullName.givenName,
                   let familyName = fullName.familyName {
                    userDefaults.fullName = PersonNameComponents(givenName: givenName, familyName: familyName)
                }
                if let email = credential.email {
                    userDefaults.email = email
                }
                if let token = credential.identityToken {
                    identityToken = String(data: token, encoding: .utf8)
                }
                if let code = credential.authorizationCode {
                    authorizationCode = String(data: code, encoding: .utf8)
                }

                authenticationState = .signedIn
                return true
            }
        case .failure(let error):
            logger.error("Error signing in with Apple", metadata: ["Error": error.localizedDescription])
            throw error
        }
        
        authenticationState = .unknown
        return false
    }
    
    func signOut() async {
        userDefaults.clearToken()
        authenticationState = .signedOut
    }
}

extension AccountService {
    /// Represents the possible authentication states of the user.
    /// - `signedIn`: The user is authenticated and signed into the app.
    /// - `signedOut`: The user is not authenticated and signed out of the app.
    /// - `unknown`: The authentication state is not yet determined or undefined.
    private enum AuthenticationState {
        case signedIn
        case signedOut
        case unknown
    }
}

extension AccountService {
    /// Defines errors that may occur during authentication.
    /// Provides localized messages for user-friendly error descriptions.
    public enum AuthenticationError: LocalizedError {
        case accountNotFound
        case accountTransferred
        case serverError

        /// A computed property to return a localized error message for each error case.
        public var errorDescription: String? {
            switch self {
            case .accountNotFound:
                return NSLocalizedString("auth.error.message.accountNotFound", comment: "Error: Account not found")
            case .serverError:
                return NSLocalizedString("auth.error.message.serverError", comment: "Error: Server error")
            case .accountTransferred:
                return NSLocalizedString("auth.error.message.accountTransferred", comment: "Error: Account transferred")
            }
        }
    }
}
