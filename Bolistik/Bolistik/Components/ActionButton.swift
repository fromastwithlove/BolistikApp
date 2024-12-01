//
//  ActionButton.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 30.11.24.
//

import SwiftUI

struct ActionButton: View {
    var text: LocalizedStringKey
    var tintColor: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(tintColor)
                .cornerRadius(8)
        }
        .padding(.horizontal)
    }
}


#Preview {
    ActionButton(text: "Get started", tintColor: .accentColor) {}
    ActionButton(text: "Send via WhatsApp", tintColor: .secondaryRed) {}
    ActionButton(text: "Send via SMS", tintColor: .red) {}
}
