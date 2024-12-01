//
//  WelcomeView.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 28.11.24.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Image("Welcome")
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
            Spacer()
            Text("Effortlessly divide your costs using Bolistik!")
                .font(.largeTitle)
                .foregroundStyle(Color.accentColor)
                .padding(.horizontal)
                .padding(.vertical)
            Text("Split your finances wisely and with ease when traveling with friends or family.")
                .font(.title3)
                .foregroundStyle(Color.gray)
                .padding(.horizontal)
            Spacer()
            ActionButton(text: "button.start", tintColor: .accentColor) {}
        }
        .padding()
    }
}

#Preview {
    WelcomeView()
}
