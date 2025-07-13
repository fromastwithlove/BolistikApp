//
//  EditProfileView.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 08.03.25.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var profileModel: UserProfileViewModel
    @ObservedObject var imageModel: ImageViewModel
    
    private let logger = AppLogger(category: "UI.EditProfileView")

    @State var userProfile: UserProfile
    @State private var showPhotoActionSheet: Bool = false
    @State private var showPhotoPicker: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            Form {
                Section {
                    HStack {
                        Spacer()
                        ImageView(model: imageModel) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: min(geometry.size.width * 0.4, 120),
                                       height: min(geometry.size.width * 0.4, 120))
                                .clipShape(.circle)
                                .clipped()
                                .overlay(alignment: .bottomTrailing) {
                                    Image(systemName: "pencil.circle.fill")
                                        .symbolRenderingMode(.multicolor)
                                        .font(.system(size: 30))
                                        .foregroundColor(.secondaryRed)
                                }
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: min(geometry.size.width * 0.4, 120),
                                       height: min(geometry.size.width * 0.4, 120))
                                .opacity(0.5)
                                .overlay(alignment: .bottomTrailing) {
                                    Image(systemName: "pencil.circle.fill")
                                        .symbolRenderingMode(.multicolor)
                                        .font(.system(size: 30))
                                        .foregroundColor(.secondaryRed)
                                }
                        }
                        .onTapGesture {
                            showPhotoActionSheet.toggle()
                        }
                        .confirmationDialog("Profile Picture", isPresented: $showPhotoActionSheet) {
                            Button {
                                showPhotoPicker.toggle()
                            } label: {
                                Text("Choose image")
                            }
                            
                            if imageModel.imageSelection != nil || userProfile.avatarPath != nil {
                                Button(role: .destructive) {
                                    imageModel.imageSelection = nil
                                    
                                    guard let path = userProfile.avatarPath else {
                                        return
                                    }
    
                                    Task {
                                        // Update image view model
                                        try await imageModel.deleteImage(path: path) //FIXME: Maybe catch an error?
                                        imageModel.imagePath = nil
                                        // Update user profile view model
                                        userProfile.avatarPath = nil
                                        await profileModel.update(profile: userProfile)
                                    }
                                } label: {
                                    Text("Delete image")
                                }
                            }
                        }
                        .photosPicker(isPresented: $showPhotoPicker, selection: $imageModel.imageSelection, matching: .any(of: [.images, .not(.screenshots)]))
                        .task(id: imageModel.imageSelection) {
                            guard imageModel.imageSelection != nil else { return }
                            let avatarPath = "\(FirebaseStoragePath.avatarsFolder.rawValue)/\(userProfile.id)/avatar"
                            do {
                                // Update image model
                                try await imageModel.uploadImage(path: avatarPath)
                                imageModel.imagePath = avatarPath
                                // Update user profile
                                userProfile.avatarPath = avatarPath
                                await profileModel.update(profile: userProfile)
                            } catch {
                                logger.error("Failed to upload avatar image: \(error.localizedDescription)")
                            }
                        }
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }
                
                Section {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundStyle(.secondaryRed)
                            .frame(width: 40)
                        TextField("Full Name", text: $userProfile.displayName)
                            .padding(.vertical, 8)
                            .autocorrectionDisabled()
                    }
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundStyle(.secondaryRed)
                            .frame(width: 40)
                        TextField("Email", text: $userProfile.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            .padding(.vertical, 8)
                    }
                }
                
                Section {
                    NavigationLink(destination: CurrenciesListView(selectedCurrency: $userProfile.currency)) {
                        HStack {
                            Image(systemName: "dollarsign.circle.fill")
                                .foregroundStyle(.secondaryRed)
                                .frame(width: 40)
                            Text("Currency")
                            Spacer()
                            Text(userProfile.currency)
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await profileModel.update(profile: userProfile)
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Text("Save")
                            .fontWeight(.bold)
                    }
                    .disabled(!profileModel.validate(profile: userProfile) || profileModel.userProfile == userProfile)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var profileModel = UserProfileViewModel(firestoreService: FirestoreService(), userID: "1")
    @Previewable @State var userProfile = UserProfile(id: "1",
                                                      email: nil,
                                                      avatarPath: "public/alan.turing.jpg",
                                                      locale: Locale.current.identifier,
                                                      currency: "EUR",
                                                      fullName: PersonNameComponents(givenName: "Alan", familyName: "Turing"))
    @Previewable @State var imageModel = ImageViewModel(firebaseStorageService: FirebaseStorageService(), imagePath: "public/alan.turing.jpg")
    
    EditProfileView(profileModel: profileModel,
                    imageModel: imageModel,
                    userProfile: userProfile)
    .environment(AppManager(services: Services()))
}
