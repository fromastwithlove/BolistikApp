//
//  EntryPointView.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 13.03.25.
//

import SwiftUI

struct EntryPointView: View {
    
    @StateObject var appManager: AppManager
    @StateObject var authenticationManager: AuthenticationManager
    
    private let logger = AppLogger(category: "BolistikApp")
    
    var body: some View {
        Group {
            switch appManager.launchState {
                case .initializing:
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                case .awaitingAuthentication:
                    LoginView()
                        .environment(appManager)
                        .environment(authenticationManager)
                        .transition(.move(edge: .bottom)
                                    .combined(with: .opacity))
                case .ready:
                    MainView()
                        .environment(appManager)
                        .environment(authenticationManager)
            }
        }
        .animation(.default, value: appManager.launchState)
        .task {
            do {
                try await authenticationManager.verifyAuthenticationState()
            } catch {
                logger.error("Verification of authentication state failed: \(error)")
            }
            
            appManager.updateAppState(isAuthenticated: authenticationManager.isAuthenticated)
        }
    }
}
