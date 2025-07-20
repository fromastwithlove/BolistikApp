//
//  AuthenticationServiceProtocol.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 19.07.25.
//

import AuthenticationServices

protocol AuthenticationServiceProtocol {
    
    // MARK: - User Information
    
    var isAuthenticated: Bool { get }
    var userID: String? { get }
    
    // MARK: - Authentication Methods
    
    @MainActor func verifyAuthenticationState() async throws
    @MainActor func prepareAppleSignIn(request: ASAuthorizationAppleIDRequest)
    @MainActor func handleSignInWithApple(result: Result<ASAuthorization, Error>) async throws
    @MainActor func handleSignInWithGoogle() async throws
    @MainActor func signOut() async
}
