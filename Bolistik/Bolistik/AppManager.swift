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
    
    // MARK: - Private Properties
    
    private let logger = AppLogger(category: "App State")
    
    // MARK: - Public Enums
    
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
    
    // MARK: - Published Properties
    
    private(set) var launchState: LaunchState = .initializing
    private(set) var services: Services
    
    init(services: Services) {
        self.services = services
    }
    
    // MARK: - Navigation
    
    /// The selected tab in the app's navigation.
    var selectedTab: Tabs = .home
    
    // MARK: - State Management
    
    /// Updates the app state based on authentication status.
    /// - Parameter isAuthenticated: Whether the user is authenticated or not.
    func updateAppState(isAuthenticated: Bool) {
        launchState = isAuthenticated ? .ready : .awaitingAuthentication
    }
}
