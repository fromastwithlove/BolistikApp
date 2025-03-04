//
//  BolistikApp.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 28.11.24.
//

import SwiftUI
import FirebaseCore
#if LOCAL_ENVIRONMENT
import FirebaseAuth
import FirebaseFirestore
#endif

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
                    LoginView(model: UserProfileViewModel(authenticationService: appManager.services.authenticationService))
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
        // Configure Firebase when the app launches
        FirebaseApp.configure()
        
        #if LOCAL_ENVIRONMENT
        // Set up Firebase Authentication to use the local emulator for testing
        Auth.auth().useEmulator(withHost: "127.0.0.1", port: 9099)
        
        let settings = Firestore.firestore().settings
        settings.host = "127.0.0.1:8080"
        settings.isSSLEnabled = false
        Firestore.firestore().settings = settings
        
        #endif
        
        return true
    }
}
