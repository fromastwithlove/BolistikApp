//
//  MainView.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 08.12.24.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var appManager: AppManager
    @EnvironmentObject private var authenticationManager: AuthenticationManager
    
    private let logger = AppLogger(category: "UI.MainView")
    
    var body: some View {
        if let user = authenticationManager.user {
            TabView(selection: $appManager.selectedTab) {
                Tab("Home", systemImage: "house", value: .home) {
                    EmptyView()
                }
                
                Tab("Groups", systemImage: "person.2", value: .groups) {
                    GroupsView(model: ExpenseGroupsViewModel())
                }

                Tab("Contacts", systemImage: "person", value: .contacts) {
                    ContactsView(model: ContactsViewModel())
                }

                Tab("Profile", systemImage: "person.crop.circle", value: .profile) {
                    ProfileView(model: UserProfileViewModel(firestoreService: appManager.services.firestoreService,
                                                            userID: user.uid))
                }
            }
        } else {
            ProgressView().progressViewStyle(CircularProgressViewStyle())
                .task {
                    logger.error("User not logged in")
                    appManager.updateAppState(isAuthenticated: false)
                }
        }
    }
}

#Preview {
    MainView()
        .environment(AppManager(services: Services()))
}
