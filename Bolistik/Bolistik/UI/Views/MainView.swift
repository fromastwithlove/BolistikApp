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
        TabView {
            Tab("Profile", systemImage: "person.crop.circle.fill") {
                ProfileView(model: UserViewModel(accountService: appManager.services.accountService))
            }
        }
    }
}

#Preview {
    let appManager = AppManager(services: Services(appConfiguration: BolistikApplication(),
                                                   networkService: NetworkService(),
                                                   accountService: AccountService()))
    MainView()
        .environmentObject(appManager)
}
