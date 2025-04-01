//
//  ProfileView.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 15.12.24.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject private var appManager: AppManager
    @EnvironmentObject private var authenticationManager: AuthenticationManager
    @StateObject var model: UserProfileViewModel
    
    @State private var path: NavigationPath = NavigationPath()

    private let logger = AppLogger(category: "UI")
    
    var body: some View {
        NavigationStack(path: $path) {
            GeometryReader { geometry in
                List {
                    Section {
                        NavigationLink(destination: EditProfileView(profileModel: model,
                                                                    imageModel: ImageViewModel(firebaseStorageService: appManager.services.firebaseStorageService,
                                                                                               imagePath: model.avatarPath))) {
                            HStack {
                                UserRowDetails(
                                    geometry: geometry,
                                    avatarPath: model.avatarPath,
                                    displayName: model.displayName,
                                    email: model.email
                                )
                                Spacer()
                                Button {
                                    // Personal QR code logic
                                } label: {
                                    Image(systemName: "qrcode")
                                }
                                .buttonStyle(.bordered)
                                .clipShape(.circle)
                                .tint(.secondaryRed)
                            }
                        }
                    }
                    
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
                            Task {
                                await authenticationManager.signOut()
                                appManager.updateAppState(isAuthenticated: authenticationManager.isAuthenticated)
                            }
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
                await model.loadUserProfile()
            }
        }
    }
}

#Preview {
    ProfileView(model: UserProfileViewModel(firestoreService: FirestoreService(), userUID: "1"))
        .environment(AppManager(services: Services()))
        .environment(AuthenticationManager(firestoreService: FirestoreService()))
}
