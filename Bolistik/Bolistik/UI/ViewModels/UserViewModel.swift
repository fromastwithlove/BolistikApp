//
//  UserViewModel.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 03.12.24.
//

import AuthenticationServices

@MainActor
final class UserViewModel: ObservableObject {
    
    // MARK: Private
    private let logger = AppLogger(category: "UI")
    private let userService: UserService
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    // MARK: Published properties
    
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var error: LocalizedError?
    @Published var fullName: PersonNameComponents?
    @Published var email: String?
    
    // MARK: Public methods
    
    public func fetchUser() {
        guard !isLoading else { return }
        isLoading = true
        Task {
            fullName = await userService.fullName
            email = await userService.email
            isLoading = false
            logger.debug("Fetching user finished")
        }
    }
    
    public func formattedFullName() -> String {
        guard let fullName = fullName else { return "" }
        
        // Check if both given name and family name are non-empty
        guard let givenName = fullName.givenName, !givenName.isEmpty else {
            // If only the family name is non-empty
            if let familyName = fullName.familyName, !familyName.isEmpty {
                return familyName
            }
            return ""
        }
        
        // If both names are non-empty, return "givenName, familyName"
        if let familyName = fullName.familyName, !familyName.isEmpty {
            return "\(givenName), \(familyName)"
        }
        
        return givenName
    }
    
    public func formattedEmail() -> String {
        guard let email = email, !email.isEmpty else {
            return ""
        }
        return email
    }
    
    public func verifyAuthenticationStatus() {
        guard !isLoading else { return }
        isLoading = true
        Task {
            do {
                try await userService.verifyAccountStatus()
                isAuthenticated = await userService.isAuthenticated
            } catch {
                isAuthenticated = false
            }
            isLoading = false
        }
    }
    
    public func signInWithApple(result: Result<ASAuthorization, Error>) {
        guard !isLoading else { return }
        isLoading = true
        logger.debug("Login attempt started")
        Task {
            do {
                let success = try await userService.signInWithApple(result: result)
                if success {
                    fullName = await userService.fullName
                    email = await userService.email
                    isAuthenticated = true
                    logger.debug("Login successful", metadata: ["Name": formattedFullName()])
                } else {
                    isAuthenticated = false
                }
            } catch {
                logger.error("Login failed", metadata: ["Error": error.localizedDescription])
            }
            isLoading = false
        }
    }
    
    public func signOut() {
        guard !isLoading else { return }
        isLoading = true
        Task {
            await userService.signOut()
            isAuthenticated = false
            isLoading = false
            logger.debug("Logout successful")
        }
    }
}
