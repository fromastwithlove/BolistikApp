//
//  AppManager.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 23.12.24.
//

import Foundation
import AuthenticationServices

@Observable
@MainActor
class AppManager: ObservableObject {
    
    // MARK: Public
    
    enum LaunchState {
        case initializing
        case awaitingAuthentication
        case ready
    }
    
    enum Tabs: Hashable {
        case home
        case groups
        case contacts
        case profile
    }
    
    // MARK: Published properties
    
    private(set) var services: Services
    private(set) var launchState: LaunchState = .initializing
    
    // MARK: Navigation
    
    var selectedTab: Tabs = .home
    
    // MARK: Authentication
    
    public func verifyAuthenticationStatus() {
        Task {
            do {
                try await services.accountService.verifyAccountStatus()
            } catch {
                logger.debug("Failed with status: \(await services.accountService.isAuthenticated), error \(error)")
            }
            launchState = await services.accountService.isAuthenticated ? .ready : .awaitingAuthentication
        }
    }
    
    public func signInWithApple(result: Result<ASAuthorization, Error>) {
        logger.debug("Login attempt started")
        Task {
            do {
                let success = try await services.accountService.signInWithApple(result: result)
                launchState = success ? .ready : .awaitingAuthentication
            } catch {
                logger.error("Login failed", metadata: ["Error": error.localizedDescription])
            }
        }
    }
    
    public func signOut() {
        Task {
            await services.accountService.signOut()
            launchState = .awaitingAuthentication
            logger.debug("Logout successful")
        }
    }
    
    // MARK: Private
    
    private let logger = AppLogger(category: "App State")
    
    init(services: Services) {
        self.services = services
    }
}
