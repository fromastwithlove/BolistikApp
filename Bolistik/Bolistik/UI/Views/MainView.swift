//
//  MainView.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 08.12.24.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var appManager: AppManager
    
    private let logger = AppLogger(category: "UI")
    
    var body: some View {
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
                ProfileView(model: UserProfileViewModel(authenticationService: appManager.services.authenticationService))
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AppManager(services: Services()))
}
