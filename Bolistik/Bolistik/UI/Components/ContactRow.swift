//
//  ContactRow.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 26.12.24.
//

import SwiftUI

struct ContactRow: View {
    
    @Binding var contact: Contact
    
    var body: some View {
        HStack {
            UserRowDetails(avatarURL: contact.imageUrl,
                           fullName: contact.formattedFullName,
                           email: contact.email)
            Spacer()
            Button(action: {
                contact.isFavourite.toggle()
            }) {
                Image(systemName: contact.isFavourite ? "star.fill" : "star")
                    .foregroundColor(contact.isFavourite ? .yellow : .gray)
                    .symbolEffect(.scale)
            }
        }
    }
}

#Preview {
    ContactRow(contact: .constant(Contact(imageUrl:"https://upload.wikimedia.org/wikipedia/commons/b/b8/Albert_Einstein_Head.jpg", fullName: PersonNameComponents(givenName: "Albert", familyName: "Einstein"), email: "albert.einstein@bolistik.kz")))
}
