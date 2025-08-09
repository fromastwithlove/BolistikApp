//
//  LoginView.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 28.11.24.
//

import SwiftUI
import AuthenticationServices
import GoogleSignInSwift

struct LoginView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dependencies) private var dependencies
    @EnvironmentObject private var appManager: AppManager
    
    private let logger = AppLogger(category: "UI.LoginView")
    
    @State private var errorString: String?
    
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
                    dependencies.authService.prepareAppleSignIn(request: request)
                } onCompletion: { result in
                    Task {
                        do {
                            try await dependencies.authService.handleSignInWithApple(result: result)
                        } catch {
                            errorString = error.localizedDescription
                        }
                        appManager.updateAppState(isAuthenticated: dependencies.authService.isAuthenticated)
                    }
                }
                .frame(height: geometry.size.height * 0.1)
                
                GoogleSignInButton(scheme: .light, style: .wide, action: {
                    Task {
                        do {
                            try await dependencies.authService.handleSignInWithGoogle()
                        } catch {
                            errorString = error.localizedDescription
                        }
                        
                        appManager.updateAppState(isAuthenticated: dependencies.authService.isAuthenticated)
                    }
                })
                .padding(.bottom)

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
    LoginView()
}
