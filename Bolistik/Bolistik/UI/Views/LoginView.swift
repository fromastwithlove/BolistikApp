//
//  LoginView.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 28.11.24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appManager: AppManager
    @StateObject var model: UserProfileViewModel
    
    private let logger = AppLogger(category: "UI")
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                Image("Welcome")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.8)
                
                Text("welcome.title")
                    .font(.largeTitle)
                    .foregroundStyle(.accent)
                    .padding(.vertical)
                    .multilineTextAlignment(.center)
                
                Text("welcome.subtitle")
                    .font(.title3)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                SignInWithAppleButtonView { request in
                    model.prepareAppleSignIn(request: request)
                } onCompletion: { result in
                    Task {
                        await model.handleSignInWithApple(result: result)
                        if await model.isAuthenticated { appManager.userDidAuthenticate() }
                    }
                }
                .frame(height: geometry.size.height * 0.1)
                
                NavigationLink(destination: EmptyView()) {
                    Text("auth.termAndCondition")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
            }
            .padding()
        }
    }
}

#Preview {
    LoginView(model: UserProfileViewModel(authenticationService: AuthenticationService(firebaseAuthService: FirebaseAuthService(), firestoreService: FirestoreService())))
}
