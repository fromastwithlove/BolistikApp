//
//  LoginView.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 30.11.24.
//

import SwiftUI

struct LoginView: View {
    
    @State private var isPhoneNumberValid: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            Text("auth.title")
                .font(.largeTitle)
                .foregroundStyle(Color.accentColor)
                .padding(.vertical)
                .padding(.horizontal)
            Text("auth.subtitle")
                .font(.subheadline)
                .foregroundStyle(Color.gray)
                .padding(.horizontal)
            Image("Auth")
                .resizable()
                .scaledToFit()
            Spacer()
                .padding(.vertical)
            NavigationLink(destination: EmptyView()) {
                ActionText(text: "auth.sendViaSMS", tintColor: .accent)
            }
            NavigationLink(destination: EmptyView()) {
                ActionText(text: "auth.sendViaWhatsApp", tintColor: .accent)
            }
            Spacer()
            NavigationLink(destination: EmptyView()) {
                Text("auth.termAndCondition")
                    .font(.subheadline)
                    .foregroundStyle(Color.gray)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
