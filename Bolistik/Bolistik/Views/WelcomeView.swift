//
//  WelcomeView.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 28.11.24.
//

import SwiftUI

struct WelcomeView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Image("Welcome")
                    .resizable()
                    .scaledToFit()
                Spacer()
                Text("welcome.title")
                    .font(.largeTitle)
                    .foregroundStyle(Color.accentColor)
                    .padding(.vertical)
                    .padding(.horizontal)
                Text("welcome.subtitle")
                    .font(.title3)
                    .foregroundStyle(Color.gray)
                    .padding(.horizontal)
                Spacer()
                MockSignInWithAppleButton()
            }
            .padding()
        }
    }
}

#Preview {
    WelcomeView().environment(\.colorScheme, .light)
}

#Preview {
    WelcomeView().environment(\.colorScheme, .dark)
}

struct MockSignInWithAppleButton: View {
    var body: some View {
        Button(action: {
            print("Simulating Sign in with Apple")
            // Mock user data
            let userIdentifier = "mock_user_id"
            let fullName = "Sam Smith"
            let email = "sam.smith@example.com"
            print("User ID: \(userIdentifier), Full Name: \(fullName), Email: \(email)")
        }) {
            Text("Sign in with Apple (Mock)")
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}
