//
//  BolistikApp.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 28.11.24.
//

import SwiftUI

@main
struct BolistikApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var appManager: AppManager = .init()
    @State private var dependencies: AppDependenciesProtocol?
    
    var body: some Scene {
        WindowGroup {
            if let dependencies = dependencies {
                RootView()
                    .environment(appManager)
                    .environment(\.dependencies, dependencies)
            } else {
                ProgressView()
                    .task {
                        dependencies = AppDependencies()
                    }
            }
        }
    }
}
