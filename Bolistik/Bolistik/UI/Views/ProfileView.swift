//
//  ProfileView.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 15.12.24.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var appManager: AppManager
    @StateObject var model: UsersViewModel
    
    @State private var path: NavigationPath = NavigationPath()
    private let logger = AppLogger(category: "UI")
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section {
                    HStack {
                        UserRowDetails(avatarURL: "https://upload.wikimedia.org/wikipedia/commons/4/40/Alan_Turing_%281912-1954%29_in_1936_at_Princeton_University_%28cropped%29.jpg",
                                       fullName: model.formattedFullName,
                                       email: model.formattedEmail)
                        Spacer()
                        Button {
                            // Personal qrcode
                        } label: {
                            Image(systemName: "qrcode")
                        }
                        .buttonStyle(.bordered)
                        .clipShape(.circle)
                        .tint(.secondaryRed)
                    }
                }
                
                Text("Personal info")
                Text("Notifications")
                Text("Account and security")
                Text("Payment methods")
                Text("App appearance")
                
                Section {
                    Text("Data and analytics")
                    Text("Help & Support")
                }
                
                Section {
                    Button(action: {
                        appManager.signOut()
                    }) {
                        Text("auth.signOut")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.red)
                    }
                }
                
                Section {
                    VStack {
                        Text("Copyright © \(String(Calendar.current.component(.year, from: Date()))) Adil Yergaliyev")
                        Text("Licensed under the Modified MIT License")
                        Text(verbatim: "25.1.0 (48)")
                    }
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            model.fetchUser()
        }
    }
}

#Preview {
    let model = UsersViewModel(accountService: AccountService())
    model.fullName = PersonNameComponents(givenName: "Adil", familyName: "Yergaliyev")
    model.email = "preview@bolistik.kz"
    return ProfileView(model: model)
}
