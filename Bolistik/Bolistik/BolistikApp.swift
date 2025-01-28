//
//  BolistikApp.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 28.11.24.
//

import SwiftUI
import FirebaseCore

@main
struct BolistikApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var appManager: AppManager = AppManager(services: Services())
    private let logger = AppLogger(category: "App State")
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appManager.launchState {
                case .initializing:
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                case .awaitingAuthentication:
                    LoginView(model: UsersViewModel(accountService: appManager.services.accountService))
                        .environment(appManager)
                        .transition(.move(edge: .bottom)
                                    .combined(with: .opacity))
                case .ready:
                    MainView()
                        .environment(appManager)
                }
            }
            .animation(.default, value: appManager.launchState)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
