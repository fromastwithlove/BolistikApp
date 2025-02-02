//
//  UsersViewModel.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 03.12.24.
//

import Foundation
import AuthenticationServices

@MainActor
@Observable
final class UsersViewModel: ObservableObject {
    
    // MARK: Private
    private let logger = AppLogger(category: "UI")
    private let accountService: AccountService
    
    init(accountService: AccountService) {
        logger.debug("Users' view model initialized")
        self.accountService = accountService
    }
    
    // MARK: Published properties
    
    var isLoading: Bool = false
    var error: LocalizedError?
    var user: InternalUser? {
        get async { await accountService.user }
    }
    
    public var isAuthenticated: Bool {
        get async { await accountService.isAuthenticated }
    }
    
    // MARK: Authentication
    
    public func prepareAppleSignIn(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email];
        // TODO: Here might be race condition
        Task {
            await accountService.prepareAppleSignIn(request: request)
        }
    }
    
    public func handleSignInWithApple(result: Result<ASAuthorization, Error>) async {
        do {
            try await accountService.handleSignInWithApple(result: result)
        } catch {
            logger.error("Login failed with Apple account: \(error)")
        }
    }
    
    public func signOut() async {
        do {
            try await accountService.signOut()
            logger.debug("Logout successful")
        } catch {
            logger.error("Signout failed with error \(error)")
        }
    }
}
