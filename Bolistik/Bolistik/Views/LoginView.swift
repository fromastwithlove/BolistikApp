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
    @EnvironmentObject var authViewModel: AuthViewModel
    
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
                    .foregroundStyle(Color.accentColor)
                    .padding(.vertical)
                    .multilineTextAlignment(.center)
                
                Text("welcome.subtitle")
                    .font(.title3)
                    .foregroundStyle(Color.gray)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                SignInWithAppleButton(.signUp) { request in
                    request.requestedScopes = [.fullName, .email]
                } onCompletion: { result in
                    authViewModel.signInWithApple(result: result)
                }
                // FIXME: The style doesn't change dynamically
                .signInWithAppleButtonStyle(
                    colorScheme == .dark ? .white : .black
                )
                .frame(height: geometry.size.height * 0.075)
            }
            .frame(maxHeight: .infinity)
            .padding()
        }
    }
}

#Preview {
    LoginView().environment(\.colorScheme, .light)
}

#Preview {
    LoginView().environment(\.colorScheme, .dark)
}
