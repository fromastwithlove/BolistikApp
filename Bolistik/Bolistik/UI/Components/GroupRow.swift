//
//  GroupRow.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 04.01.25.
//

import SwiftUI

struct GroupRow: View {
    
    @EnvironmentObject private var appManager: AppManager
    @Binding var group: ExpenseGroup
    let geometry: GeometryProxy
    
    var body: some View {
        HStack {
            AsyncImage(url: group.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(3/2, contentMode: .fit)
            } placeholder: {
                Image(systemName: "photo")
                    .foregroundStyle(.secondaryRed)
                    .opacity(0.5)
                    .symbolEffect(.bounce.down.wholeSymbol)
            }
            .frame(width: geometry.size.width * 0.25,
                   height: geometry.size.width * 0.16)
            .aspectRatio(3/2, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 2)
            
            VStack(alignment: .leading) {
                Text(group.name)
                    .font(.headline)
                HStack(spacing: -10) {
                    ForEach(group.members) { member in
                        ImageView(model: ImageViewModel(firebaseStorageService: appManager.services.firebaseStorageService,
                                                        imagePath: member.avatarPath)) { image in
                            image
                                .frame(width: min(geometry.size.width * 0.08, 40),
                                       height: min(geometry.size.width * 0.08, 40))
                                .clipShape(.circle)
                                .overlay(Circle().stroke(.white, lineWidth: 0.5))
                                .shadow(radius: 1)
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .frame(width: min(geometry.size.width * 0.08, 40),
                                       height: min(geometry.size.width * 0.08, 40))
                                .opacity(0.5)
                                .symbolEffect(.bounce.down.wholeSymbol)
                        }
                    }
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    GeometryReader { geometry in
        GroupRow(group: .constant(ExpenseGroup(
            imageURL: URL(string: "https://wallpaperaccess.com/full/203332.jpg")!,
            name: "Trip in Paris",
            type: "trip",
            members: [
                Contact(id: "1", email: "marie.curie@bolistik.kz", avatarPath: "public/marie.curie.jpg", locale: Locale.current.identifier, currency: "USD", fullName: PersonNameComponents(givenName: "Marie", familyName: "Curie")),
                Contact(id: "2", email: "nikola.tesla@bolistik.kz", avatarPath: "public/nikola.tesla.jpg", locale: Locale.current.identifier, currency: "EUR", fullName: PersonNameComponents(givenName: "Nikola", familyName: "Tesla")),
                Contact(id: "3", email: "albert.einstein@bolistik.kz", avatarPath: "public/albert.einstein.jpg", locale: Locale.current.identifier, currency: "CHF", fullName: PersonNameComponents(givenName: "Albert", familyName: "Einstein")),
                Contact(id: "4", email: "richard.feynman@bolistik.kz", avatarPath: "public/richard.feynman.jpg", locale: Locale.current.identifier, currency: "USD", fullName: PersonNameComponents(givenName: "Richard", familyName: "Feynman"))
            ]
        )), geometry: geometry)
    }
}
