//
//  MainView.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 08.12.24.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var model: UserViewModel
    
    private let logger = AppLogger(category: "UI")
    
    var body: some View {
        TabView {
            Tab("Profile", systemImage: "person.crop.circle.fill") {
                ProfileView(model: model)
            }
        }
    }
}

#Preview {
    MainView(model: UserViewModel(userService: UserService()))
}
