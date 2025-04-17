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
                        if let profile = model.userProfile {
                            NavigationLink(destination: EditProfileView(profileModel: model,
                                                                        imageModel: ImageViewModel(firebaseStorageService: appManager.services.firebaseStorageService,
                                                                                                   imagePath: model.userProfile?.avatarPath), userProfile: profile)) {
                                HStack {
                                    UserRowDetails(
                                        geometry: geometry,
                                        avatarPath: profile.avatarPath,
                                        displayName: profile.displayName,
                                        email: profile.email
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
                        } else {
                            Text("Profile not set up yet.")
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
                            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                               let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                                Text(verbatim: "\(version) (\(build))")
                            }
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
    ProfileView(model: UserProfileViewModel(firestoreService: FirestoreService(), userID: "1"))
        .environment(AppManager(services: Services()))
        .environment(AuthenticationManager(firestoreService: FirestoreService()))
}
