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
    @StateObject private var appManager: AppManager = AppManager(services: Services(appConfiguration: BolistikApplication(),
                                                                                    networkService: NetworkService(),
                                                                                    accountService: AccountService()))
    private let logger = AppLogger(category: "App State")
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appManager.launchState {
                case .initializing:
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                case .awaitingAuthentication:
                    LoginView()
                        .environment(appManager)
                        .transition(.move(edge: .bottom)
                                    .combined(with: .opacity))
                case .ready:
                    MainView()
                        .environment(appManager)
                        .transition(.move(edge: .top)
                                    .combined(with: .opacity))
                }
            }
            .animation(.default, value: appManager.launchState)
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                logger.debug("App is active")
                appManager.verifyAuthenticationStatus()
            }
        }
    }
}
