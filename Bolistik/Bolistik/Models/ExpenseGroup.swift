//
//  ExpenseGroup.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 04.01.25.
//

import Foundation

struct ExpenseGroup: Codable, Identifiable {
    var id = UUID()
    let imageURL: String?
    let name: String
    let type: String
    let members: [Contact]
    
    init(id: UUID = UUID(), imageURL: String?, name: String, type: String, members: [Contact]) {
        self.id = id
        self.imageURL = imageURL
        self.name = name
        self.type = type
        self.members = members
    }
    
    static let samples = [
        ExpenseGroup(imageURL: "https://wallpaperaccess.com/full/203332.jpg",
              name: "Conference in Paris",
              type: "trip",
              members: [
                Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/c/c8/Marie_Curie_c._1920s.jpg", fullName: PersonNameComponents(givenName: "Marie", familyName: "Curie"), email: "marie.curie@bolistik.kz"),
                Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/7/79/Tesla_circa_1890.jpeg", fullName: PersonNameComponents(givenName: "Nikola", familyName: "Tesla"), email: "nikola.tesla@bolistik.kz"),
                Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/3/3e/Einstein_1921_by_F_Schmutzer_-_restoration.jpg", fullName: PersonNameComponents(givenName: "Albert", familyName: "Einstein"), email: "albert.einstein@bolistik.kz"),
                Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/en/4/42/Richard_Feynman_Nobel.jpg", fullName: PersonNameComponents(givenName: "Richard", familyName: "Feynman"), email: "richard.feynman@bolistik.kz"),
                Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/f/f7/Portrait_of_Sir_Isaac_Newton%2C_1689_%28brightened%29.jpg", fullName: PersonNameComponents(givenName: "Isaac", familyName: "Newton"), email: "isaac.newton@bolistik.kz"),
                Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/2/2e/Charles_Darwin_seated_crop.jpg", fullName: PersonNameComponents(givenName: "Charles", familyName: "Darwin"), email: "charles.darwin@bolistik.kz"),
                Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/7/7e/Michael_Faraday_sitting_crop.jpg", fullName: PersonNameComponents(givenName: "Michael", familyName: "Faraday"), email: "michael.faraday@bolistik.kz"),
                Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/3/3d/Lise_Meitner.tif", fullName: PersonNameComponents(givenName: "Lise", familyName: "Meitner"), email: "lise.meitner@bolistik.kz")
              ]),
        ExpenseGroup(imageURL: "https://c.pxhere.com/photos/0f/d5/sunset_france_dordogne_bordeaux_countryside_europe_landscape_french-1323550.jpg!d",
              name: "Road trip with Friends",
              type: "trip",
              members: [
                Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/c/c8/Marie_Curie_c._1920s.jpg", fullName: PersonNameComponents(givenName: "Marie", familyName: "Curie"), email: "marie.curie@bolistik.kz"),
                Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/7/79/Tesla_circa_1890.jpeg", fullName: PersonNameComponents(givenName: "Nikola", familyName: "Tesla"), email: "nikola.tesla@bolistik.kz"),
                Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/3/3e/Einstein_1921_by_F_Schmutzer_-_restoration.jpg", fullName: PersonNameComponents(givenName: "Albert", familyName: "Einstein"), email: "albert.einstein@bolistik.kz"),
                Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/en/4/42/Richard_Feynman_Nobel.jpg", fullName: PersonNameComponents(givenName: "Richard", familyName: "Feynman"), email: "richard.feynman@bolistik.kz"),
              ]),
        ExpenseGroup(imageURL: "https://www.soprovich.com/i-28f8046e/real-estate/d82_0085.luxury-lg.default.jpg",
              name: "Family expenses",
              type: "home",
              members: [
                Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/c/c8/Marie_Curie_c._1920s.jpg", fullName: PersonNameComponents(givenName: "Marie", familyName: "Curie"), email: "marie.curie@bolistik.kz"),
                Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/7/79/Tesla_circa_1890.jpeg", fullName: PersonNameComponents(givenName: "Nikola", familyName: "Tesla"), email: "nikola.tesla@bolistik.kz"),
              ])
    ]
}
