//
//  ActionText.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 30.11.24.
//

import SwiftUI

struct ActionText: View {
    var text: LocalizedStringKey
    var tintColor: Color

    var body: some View {
        Text(text)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(tintColor)
            .cornerRadius(8)
    }
}


#Preview {
    ActionText(text: "welcome.start", tintColor: .accentColor)
    ActionText(text: "welcome.title", tintColor: .secondaryRed)
    ActionText(text: "auth.sendViaSMS", tintColor: .secondaryRed)
}
