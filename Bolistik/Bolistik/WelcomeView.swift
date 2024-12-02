//
//  WelcomeView.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 28.11.24.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
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
                NavigationLink(destination: LoginView()) {
                    ActionText(text: "welcome.start", tintColor: .accentColor)
                }
            }
            .padding()
        }
    }
}

#Preview {
    WelcomeView()
}
