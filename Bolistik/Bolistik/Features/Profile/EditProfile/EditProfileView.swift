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
    @ObservedObject var profileModel: ProfileViewModel
    @ObservedObject var imageModel: ImageViewModel
    
    private let logger = AppLogger(category: "UI.EditProfileView")

    @State var profile: Contact
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
                        .confirmationDialog("Contact Picture", isPresented: $showPhotoActionSheet) {
                            Button {
                                showPhotoPicker.toggle()
                            } label: {
                                Text("Choose image")
                            }
                            
                            if imageModel.imageSelection != nil || profile.avatarPath != nil {
                                Button(role: .destructive) {
                                    imageModel.imageSelection = nil
                                    
                                    guard let path = profile.avatarPath else {
                                        return
                                    }
    
                                    Task {
                                        // Update image view model
                                        try await imageModel.deleteImage(path: path) //FIXME: Maybe catch an error?
                                        imageModel.imagePath = nil
                                        // Update profile view model
                                        profile.avatarPath = nil
                                        await profileModel.update(profile: profile)
                                    }
                                } label: {
                                    Text("Delete image")
                                }
                            }
                        }
                        .photosPicker(isPresented: $showPhotoPicker, selection: $imageModel.imageSelection, matching: .any(of: [.images, .not(.screenshots)]))
                        .task(id: imageModel.imageSelection) {
                            guard imageModel.imageSelection != nil else { return }
                            let avatarPath = "\(FirebaseStoragePath.avatarsFolder.rawValue)/\(profile.id)/avatar"
                            do {
                                // Update image model
                                try await imageModel.uploadImage(path: avatarPath)
                                imageModel.imagePath = avatarPath
                                // Update user profile
                                profile.avatarPath = avatarPath
                                await profileModel.update(profile: profile)
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
                        TextField("Full Name", text: $profile.displayName)
                            .padding(.vertical, 8)
                            .autocorrectionDisabled()
                    }
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundStyle(.secondaryRed)
                            .frame(width: 40)
                        TextField("Email", text: $profile.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            .padding(.vertical, 8)
                    }
                }
                
                Section {
                    NavigationLink(destination: CurrenciesListView(selectedCurrency: $profile.currency)) {
                        HStack {
                            Image(systemName: "dollarsign.circle.fill")
                                .foregroundStyle(.secondaryRed)
                                .frame(width: 40)
                            Text("Currency")
                            Spacer()
                            Text(profile.currency)
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await profileModel.update(profile: profile)
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Text("Save")
                            .fontWeight(.bold)
                    }
                    .disabled(!profileModel.validate(profile: profile) || profileModel.currentUser == profile)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var profileModel = ProfileViewModel(profileRepository: ProfileRepository(firestoreService: FirestoreService()), userID: "1")
    @Previewable @State var profile = Contact(id: "1",
                                                      email: nil,
                                                      avatarPath: "public/alan.turing.jpg",
                                                      locale: Locale.current.identifier,
                                                      currency: "EUR",
                                                      fullName: PersonNameComponents(givenName: "Alan", familyName: "Turing"))
    @Previewable @State var imageModel = ImageViewModel(storageService: FirebaseStorageService(), imagePath: "public/alan.turing.jpg")
    
    EditProfileView(profileModel: profileModel,
                    imageModel: imageModel,
                    profile: profile)
    .environment(AppManager())
}
