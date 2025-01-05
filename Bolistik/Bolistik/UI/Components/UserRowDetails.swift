//
//  UserRowDetails.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 28.12.24.
//

import SwiftUI

struct UserRowDetails: View {
    
    var avatarURL: String
    var fullName: String
    var email: String
    
    var body: some View {
        HStack {
            // Profile Image
            AsyncImage(url: URL(string: avatarURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 65, height: 65)
                    .clipShape(Circle())
            } placeholder: {
                Image(systemName: "photo.circle")
                    .resizable()
                    .frame(width: 65, height: 65)
                    .clipShape(.circle)
                    .foregroundStyle(.secondaryRed)
                    .opacity(0.5)
                    .symbolEffect(.bounce.down.wholeSymbol)
            }
            // Full name
            VStack(alignment: .leading) {
                Text(fullName)
                    .font(.headline)
                Text(email)
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    UserRowDetails(avatarURL: "https://upload.wikimedia.org/wikipedia/commons/4/40/Alan_Turing_%281912-1954%29_in_1936_at_Princeton_University_%28cropped%29.jpg",
                   fullName: "Alan Turing",
                   email: "alan.turing@bolistik.kz")
}
