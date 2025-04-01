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
    
    private let logger = AppLogger(category: "UI")

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
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: min(geometry.size.width * 0.4, 120),
                                       height: min(geometry.size.width * 0.4, 120))
                                .opacity(0.5)
                        }
                        .overlay(alignment: .bottomTrailing) {
                            PhotosPicker(selection: $imageModel.imageSelection,
                                         matching: .images,
                                         photoLibrary: .shared()) {
                                Image(systemName: "pencil.circle.fill")
                                    .symbolRenderingMode(.multicolor)
                                    .font(.system(size: 30))
                                    .foregroundColor(.secondaryRed)
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
                        TextField("Full Name", text: $profileModel.displayName)
                            .padding(.vertical, 8)
                            .autocorrectionDisabled()
                    }
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundStyle(.secondaryRed)
                            .frame(width: 40)
                        TextField("Email", text: $profileModel.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            .padding(.vertical, 8)
                    }
                }
                
                Section {
                    NavigationLink(destination: CurrenciesListView(selectedCurrency: $profileModel.currency)) {
                        HStack {
                            Image(systemName: "dollarsign.circle.fill")
                                .foregroundStyle(.secondaryRed)
                                .frame(width: 40)
                            Text("Currency")
                            Spacer()
                            Text(profileModel.currency)
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
            .navigationBarItems(trailing: Button(action: {
                Task {
                    if imageModel.imageSelection != nil {
                        let avatarPath = "\(FirebaseStoragePath.avatarsFolder.rawValue)/\(profileModel.userId)/avatar"
                        try await imageModel.uploadImage(path: avatarPath)
                        
                        profileModel.avatarPath = avatarPath
                    }
                    
                    await profileModel.updateUserProfile()
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Save")
                    .fontWeight(.bold)
            }
                .disabled(!profileModel.validateUserProfile())
            )
        }
    }
}

#Preview {
    @Previewable @State var profileModel = UserProfileViewModel(firestoreService: FirestoreService(), userUID: "1")
    @Previewable @State var imageModel = ImageViewModel(firebaseStorageService: FirebaseStorageService(), imagePath: "alan.turing")
    
    EditProfileView(profileModel: profileModel, imageModel: imageModel)
        .environment(AppManager(services: Services()))
}
