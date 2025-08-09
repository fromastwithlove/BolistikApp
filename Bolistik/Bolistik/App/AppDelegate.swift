//
//  AppDelegate.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 20.07.25.
//

import UIKit

import FirebaseCore
#if LOCAL_ENVIRONMENT
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
#endif

class AppDelegate: NSObject, UIApplicationDelegate {

    private let logger = AppLogger(category: "AppDelegate")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Configure Firebase when the app launches
        FirebaseApp.configure()
        
        #if LOCAL_ENVIRONMENT
        logger.info("Running in local environment setup")
        // Set up Firebase Authentication to use the local emulator for testing
        Auth.auth().useEmulator(withHost: "127.0.0.1", port: 9099)
        
        // Set up Firestore to use the local emulator for testing
        let settings = Firestore.firestore().settings
        settings.host = "127.0.0.1:8080"
        settings.isSSLEnabled = false
        Firestore.firestore().settings = settings
        
        // Set up Firebase Storage to use the local emulator for testing
        let storage = Storage.storage()
        storage.useEmulator(withHost:"127.0.0.1", port:9199)

        #endif
        
        return true
    }
}
