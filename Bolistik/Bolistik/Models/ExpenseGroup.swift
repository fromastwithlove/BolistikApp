//
//  ExpenseGroup.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 04.01.25.
//

import Foundation

struct ExpenseGroup: Codable, Identifiable {
    var id = UUID()
    let imageURL: URL?
    let name: String
    let type: String
    let members: [Contact]
    
    init(id: UUID = UUID(), imageURL: URL?, name: String, type: String, members: [Contact]) {
        self.id = id
        self.imageURL = imageURL
        self.name = name
        self.type = type
        self.members = members
    }
    
    static let samples = [
        ExpenseGroup(
            imageURL: URL(string: "https://wallpaperaccess.com/full/203332.jpg")!,
            name: "Conference in Paris",
            type: "trip",
            members: [
                Contact(avatarPath: "public/marie.curie.jpg", fullName: PersonNameComponents(givenName: "Marie", familyName: "Curie"), email: "marie.curie@bolistik.kz"),
                Contact(avatarPath: "public/nikola.tesla.jpg", fullName: PersonNameComponents(givenName: "Nikola", familyName: "Tesla"), email: "nikola.tesla@bolistik.kz"),
                Contact(avatarPath: "public/albert.einstein.jpg", fullName: PersonNameComponents(givenName: "Albert", familyName: "Einstein"), email: "albert.einstein@bolistik.kz"),
                Contact(avatarPath: "public/richard.feynman.jpg", fullName: PersonNameComponents(givenName: "Richard", familyName: "Feynman"), email: "richard.feynman@bolistik.kz"),
                Contact(avatarPath: "public/isaac.newton.jpg", fullName: PersonNameComponents(givenName: "Isaac", familyName: "Newton"), email: "isaac.newton@bolistik.kz"),
                Contact(avatarPath: "public/charles.darwin.jpg", fullName: PersonNameComponents(givenName: "Charles", familyName: "Darwin"), email: "charles.darwin@bolistik.kz"),
                Contact(avatarPath: "public/michael.faraday.jpg", fullName: PersonNameComponents(givenName: "Michael", familyName: "Faraday"), email: "michael.faraday@bolistik.kz"),
                Contact(avatarPath: "public/lise.meitner.jpg", fullName: PersonNameComponents(givenName: "Lise", familyName: "Meitner"), email: "lise.meitner@bolistik.kz")
            ]
        ),
        ExpenseGroup(
            imageURL: URL(string: "https://c.pxhere.com/photos/0f/d5/sunset_france_dordogne_bordeaux_countryside_europe_landscape_french-1323550.jpg!d")!,
            name: "Road trip with Friends",
            type: "trip",
            members: [
                Contact(avatarPath: "public/marie.curie.jpg", fullName: PersonNameComponents(givenName: "Marie", familyName: "Curie"), email: "marie.curie@bolistik.kz"),
                Contact(avatarPath: "public/nikola.tesla.jpg", fullName: PersonNameComponents(givenName: "Nikola", familyName: "Tesla"), email: "nikola.tesla@bolistik.kz"),
                Contact(avatarPath: "public/albert.einstein.jpg", fullName: PersonNameComponents(givenName: "Albert", familyName: "Einstein"), email: "albert.einstein@bolistik.kz"),
                Contact(avatarPath: "public/richard.feynman.jpg", fullName: PersonNameComponents(givenName: "Richard", familyName: "Feynman"), email: "richard.feynman@bolistik.kz")
            ]
        ),
        ExpenseGroup(
            imageURL: URL(string: "https://www.soprovich.com/i-28f8046e/real-estate/d82_0085.luxury-lg.default.jpg")! ,
            name: "Family expenses",
            type: "home",
            members: [
                Contact(avatarPath: "public/marie.curie.jpg", fullName: PersonNameComponents(givenName: "Marie", familyName: "Curie"), email: "marie.curie@bolistik.kz"),
                Contact(avatarPath: "public/nikola.tesla.jpg", fullName: PersonNameComponents(givenName: "Nikola", familyName: "Tesla"), email: "nikola.tesla@bolistik.kz")
            ]
        )
    ]
}
