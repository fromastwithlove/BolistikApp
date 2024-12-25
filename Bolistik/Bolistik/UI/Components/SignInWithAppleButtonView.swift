//
//  SignInWithAppleButtonView.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 08.12.24.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleButtonView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var onRequest: (ASAuthorizationAppleIDRequest) -> Void
    var onCompletion: ((Result<ASAuthorization, Error>) -> Void)
    
    var body: some View {
        if colorScheme == .dark {
            SignInWithAppleButton(.signUp,
                                  onRequest: onRequest,
                                  onCompletion: onCompletion)
            .signInWithAppleButtonStyle(.white)
            .padding(.vertical)
        } else {
            SignInWithAppleButton(.signUp,
                                  onRequest: onRequest,
                                  onCompletion: onCompletion)
            .signInWithAppleButtonStyle(.black)
            .padding(.vertical)
        }
    }
}

#Preview {
    SignInWithAppleButtonView(onRequest: { _ in }, onCompletion: { _ in })
        .frame(height: 60)
        .padding()
}
