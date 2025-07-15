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
            ContactRowDetails(geometry: geometry,
                           avatarPath: contact.avatarPath,
                           displayName: contact.displayName,
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
    @Previewable @State var contact: Contact = Contact(id: "1",
                                                       email: "albert.einstein@bolistik.kz",
                                                       avatarPath: "public/albert.einstein.jpg",
                                                       locale: Locale.current.identifier,
                                                       currency: "USD",
                                                       fullName: PersonNameComponents(givenName: "Albert",
                                                                                      familyName: "Einstein"))
    GeometryReader { geometry in
        ContactRow(contact:.constant(contact), geometry: geometry)
    }
}
