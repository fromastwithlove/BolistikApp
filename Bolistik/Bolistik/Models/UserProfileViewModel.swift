//
//  UserProfileViewModel.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 03.12.24.
//

import Foundation
import AuthenticationServices

@MainActor
@Observable
final class UserProfileViewModel: ObservableObject {
    
    // MARK: Private Properties
    
    private let logger = AppLogger(category: "UI")
    private let authenticationService: AuthenticationService
    
    init(authenticationService: AuthenticationService) {
        logger.debug("Users profile view model initialized")
        self.authenticationService = authenticationService
    }
    
    // MARK: Published properties
    
    var isLoading: Bool = false
    var error: LocalizedError?
    var userProfile: UserProfile?
    
    public var isAuthenticated: Bool {
        get async { await authenticationService.isAuthenticated }
    }
    
    // MARK: Public methods
    
    public func loadUserProfile() {
        Task {
            let profile = await authenticationService.userProfile
            userProfile = profile
        }
    }
    
    // MARK: Authentication
    
    public func prepareAppleSignIn(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email];
        // TODO: Here might be race condition
        Task {
            await authenticationService.prepareAppleSignIn(request: request)
        }
    }
    
    public func handleSignInWithApple(result: Result<ASAuthorization, Error>) async {
        do {
            try await authenticationService.handleSignInWithApple(result: result)
        } catch {
            logger.error("Login failed with Apple account: \(error)")
        }
    }
    
    public func signOut() async {
        do {
            try await authenticationService.signOut()
            logger.debug("Logout successful")
        } catch {
            logger.error("Signout failed with error \(error)")
        }
    }
    
}
