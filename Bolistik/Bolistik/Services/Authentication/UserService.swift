//
//  UserService.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 08.12.24.
//

import AuthenticationServices

enum AuthenticationState {
    case signedIn
    case signedOut
    case unknown
}

actor UserService {

    // MARK: Private
    private let logger = AppLogger(category: "Session")
    private var authenticationState: AuthenticationState = .unknown
    
    // MARK: Public
    
    public var isAuthenticated: Bool {
        get async { authenticationState == .signedIn }
    }
    
    public var fullName: PersonNameComponents? {
        get async { BolistikUserDefaults.fullName }
    }
    
    public var email: String? {
        get async { BolistikUserDefaults.email }
    }
    
    func verifyAccountStatus() async throws {
        logger.debug("Account verification started")
        guard let currentUserID = BolistikUserDefaults.token else {
            authenticationState = .unknown
            logger.debug("Account is not found")
            return
        }

        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        do {
            let credentialState = try await appleIDProvider.credentialState(forUserID: currentUserID)
            switch credentialState {
            case .authorized:
                logger.debug("Account is signed in")
                authenticationState = .signedIn
            case .revoked, .notFound:
                logger.debug("Account is revoked or not found")
                authenticationState = .unknown
                BolistikUserDefaults.clearToken()
                throw AuthenticationError.accountNotFound
            case .transferred:
                authenticationState = .signedOut
                logger.debug("Account is signed out")
                throw AuthenticationError.accountTransferred
            default:
                logger.debug("Account state is unknown")
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
                BolistikUserDefaults.token = credential.user
                if let fullName = credential.fullName,
                   let givenName = fullName.givenName,
                   let familyName = fullName.familyName {
                    BolistikUserDefaults.fullName = PersonNameComponents(givenName: givenName, familyName: familyName)
                }
                if let email = credential.email {
                    BolistikUserDefaults.email = email
                }

                authenticationState = .signedIn
                return true
            }
        case .failure(let error):
            logger.error("Error signing in with Apple", metadata: ["Description": error.localizedDescription])
            throw error
        }
        
        authenticationState = .unknown
        return false
    }
    
    func signOut() async {
        BolistikUserDefaults.clearToken()
        authenticationState = .signedOut
    }
}
