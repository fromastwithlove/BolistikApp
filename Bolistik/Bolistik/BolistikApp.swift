//
//  BolistikApp.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 28.11.24.
//

import SwiftUI

@main
struct BolistikApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject private var model: UserViewModel
    
    let logger = AppLogger(category: "App")
    var services: Services
    
    init() {
        logger.debug("App is initialized")
        services = Services(appConfiguration: BolistikApplication(), networkService: NetworkService(), userService: UserService())
        model = UserViewModel(userService: services.userService)
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if model.isAuthenticated {
                    MainView(model: model)
                        .transition(.slide)
                } else {
                    LoginView(model: model)
                        .transition(.slide)
                }
            }
            .animation(.easeInOut(duration: 0.5), value: model.isAuthenticated)
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                logger.debug("App is active")
                model.verifyAuthenticationStatus()
            }
        }
    }
}
