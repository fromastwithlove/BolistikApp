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
                Contact(avatarPath: "public/marie.curie.jpg", fullName: PersonNameComponents(givenName: "Marie", familyName: "Curie"), email: "marie.curie@bolistik.kz"),
                Contact(avatarPath: "public/nikola.tesla.jpg", fullName: PersonNameComponents(givenName: "Nikola", familyName: "Tesla"), email: "nikola.tesla@bolistik.kz"),
                Contact(avatarPath: "public/albert.einstein.jpg", fullName: PersonNameComponents(givenName: "Albert", familyName: "Einstein"), email: "albert.einstein@bolistik.kz"),
                Contact(avatarPath: "public/richard.feynman.jpg", fullName: PersonNameComponents(givenName: "Richard", familyName: "Feynman"), email: "richard.feynman@bolistik.kz")
            ]
        )), geometry: geometry)
    }
}
