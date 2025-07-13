//
//  ContactRow.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 26.12.24.
//

import SwiftUI

struct ContactRow: View {
    
    @Binding var contact: Contact
    let geometry: GeometryProxy
    
    var body: some View {
        HStack {
            UserRowDetails(geometry: geometry,
                           avatarPath: contact.avatarPath,
                           displayName: contact.formattedFullName,
                           email: contact.email)
            Spacer()
            Button(action: {
                contact.isFavorite.toggle()
            }) {
                Image(systemName: contact.isFavorite ? "star.fill" : "star")
                    .foregroundColor(contact.isFavorite ? .yellow : .gray)
                    .symbolEffect(.scale)
            }
        }
    }
}

#Preview {
    GeometryReader { geometry in
        ContactRow(contact:
                .constant(Contact(avatarPath: "public/albert.einstein.jpg",
                                  fullName: PersonNameComponents(givenName: "Albert", familyName: "Einstein"),
                                  email: "albert.einstein@bolistik.kz")),
                   geometry: geometry)
    }
}
