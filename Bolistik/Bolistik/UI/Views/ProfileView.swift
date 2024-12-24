//
//  ProfileView.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 15.12.24.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var appManager: AppManager
    @ObservedObject var model: UserViewModel
    
    private let logger = AppLogger(category: "UI")
    
    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .shadow(radius: 10)
            
            Text(model.formattedFullName())
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 10)
            
            Text(model.formattedEmail())
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Divider()
                .padding(.vertical, 20)
            
            Spacer()
            
            Button(action: {
                appManager.signOut()
            }) {
                ActionText(text: "auth.signOut", tintColor: .red)
            }
            .padding()
        }
        .task {
            model.fetchUser()
        }
    }
}

// TODO: Make preview work
#Preview {
    let model = UserViewModel(accountService: AccountService())
    model.email = "name.surname@bolistik.kz"
    model.fullName = PersonNameComponents(givenName: "Name", familyName: "Surname")
    return ProfileView(model: model)
}
