//
//  EntryPointView.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 13.03.25.
//

import SwiftUI

struct EntryPointView: View {
    
    @StateObject var appManager: AppManager
    @Environment(\.dependencies) var dependencies
    
    private let logger = AppLogger(category: "BolistikApp")
    
    var body: some View {
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
            }
        }
        .animation(.default, value: appManager.launchState)
        .task {
            do {
                try await dependencies.authService.verifyAuthenticationState()
            } catch {
                logger.error("Verification of authentication state failed: \(error)")
            }
            
            appManager.updateAppState(isAuthenticated: dependencies.authService.isAuthenticated)
        }
    }
}
