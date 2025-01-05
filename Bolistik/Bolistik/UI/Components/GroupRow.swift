//
//  GroupRow.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 04.01.25.
//

import SwiftUI

struct GroupRow: View {
    
    @Binding var group: ExpenseGroup
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: group.imageURL!)) { image in
                image
                    .resizable()
                    .aspectRatio(3/2, contentMode: .fit)
            } placeholder: {
                Image(systemName: "photo")
                    .foregroundStyle(.secondaryRed)
                    .opacity(0.5)
                    .symbolEffect(.bounce.down.wholeSymbol)
            }
            .frame(width: 90, height: 60)
            .aspectRatio(3/2, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 2)
            
            VStack(alignment: .leading) {
                Text(group.name)
                    .font(.headline)
                HStack(spacing: -10) {
                    ForEach(group.members) { member in
                        AsyncImage(url: URL(string: member.imageUrl)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .foregroundStyle(.secondary)
                                .opacity(0.5)
                                .symbolEffect(.bounce.down.wholeSymbol)
                        }
                        .frame(width: 30, height: 30)
                        .clipShape(.circle)
                        .overlay(Circle().stroke(.white, lineWidth: 0.5))
                        .shadow(radius: 1)
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
    GroupRow(group: .constant(ExpenseGroup(imageURL: "https://wallpaperaccess.com/full/203332.jpg",
                                         name: "Trip in Paris",
                                         type: "trip",
                                         members: [
                                            Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/c/c8/Marie_Curie_c._1920s.jpg", fullName: PersonNameComponents(givenName: "Marie", familyName: "Curie"), email: "marie.curie@bolistik.kz"),
                                            Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/7/79/Tesla_circa_1890.jpeg", fullName: PersonNameComponents(givenName: "Nikola", familyName: "Tesla"), email: "nikola.tesla@bolistik.kz"),
                                            Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/3/3e/Einstein_1921_by_F_Schmutzer_-_restoration.jpg", fullName: PersonNameComponents(givenName: "Albert", familyName: "Einstein"), email: "albert.einstein@bolistik.kz"),
                                            Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/en/4/42/Richard_Feynman_Nobel.jpg", fullName: PersonNameComponents(givenName: "Richard", familyName: "Feynman"), email: "richard.feynman@bolistik.kz"),
                                         ])))
}
