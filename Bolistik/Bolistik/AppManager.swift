//
//  AppManager.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 23.12.24.
//

import Foundation

@Observable
@MainActor
class AppManager: ObservableObject {
    
    // MARK: Private
    
    private let logger = AppLogger(category: "App State")
    
    init(services: Services) {
        self.services = services
        
        Task {
            await verifyAuthenticationState()
        }
    }
    
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
    
    // MARK: State manager
    
    private func verifyAuthenticationState() async {
        do {
            try await services.accountService.verifyAccountStatus()
        } catch {
            logger.debug("Apple verification failed with error \(error)")
        }
        launchState = await services.accountService.isAuthenticated ? .ready : .awaitingAuthentication
    }
    
    func userDidAuthenticate() {
        logger.debug("Signed in successfully")
        launchState = .ready
    }
    
    func userDidLogout() {
        logger.debug("Signed out successfully")
        launchState = .awaitingAuthentication
    }
}
