//
//  ContactView.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 15.12.24.
//

import SwiftUI

struct ContactView: View {
    
    @EnvironmentObject private var appManager: AppManager
    @Environment(\.dependencies) private var dependencies
    @StateObject var model: ContactViewModel
    
    @State private var path: NavigationPath = NavigationPath()

    private let logger = AppLogger(category: "UI.ContactView")
    
    var body: some View {
        NavigationStack(path: $path) {
            GeometryReader { geometry in
                List {
                    Section {
                        if let currentUser = model.currentUser {
                            NavigationLink(destination: EditContactView(contactModel: model,
                                                                        imageModel: ImageViewModel(storageService: dependencies.storageService,
                                                                                                   imagePath: model.currentUser?.avatarPath), contact: currentUser)) {
                                HStack {
                                    ContactRowDetails(
                                        geometry: geometry,
                                        avatarPath: currentUser.avatarPath,
                                        displayName: currentUser.displayName,
                                        email: currentUser.email
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
                            Text("Current user is not set up yet.")
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
                                await dependencies.authService.signOut()
                                appManager.updateAppState(isAuthenticated: dependencies.authService.isAuthenticated)
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
                await model.loadCurrentUser()
            }
        }
    }
}

#Preview {
    @Previewable @State var firestoreService: FirestoreService = FirestoreService()
    ContactView(model: ContactViewModel(firestoreService: FirestoreService(), userID: "1"))
        .environment(AppManager())
        .environment(\.dependencies, AppDependencies(firestoreService: FirestoreService()))
}
