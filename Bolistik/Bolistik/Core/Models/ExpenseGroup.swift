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
                Contact(id: "1", email: "marie.curie@bolistik.kz", avatarPath: "public/marie.curie.jpg", locale: Locale.current.identifier, currency: "USD", fullName: PersonNameComponents(givenName: "Marie", familyName: "Curie")),
                Contact(id: "2", email: "nikola.tesla@bolistik.kz", avatarPath: "public/nikola.tesla.jpg", locale: Locale.current.identifier, currency: "EUR", fullName: PersonNameComponents(givenName: "Nikola", familyName: "Tesla")),
                Contact(id: "3", email: "albert.einstein@bolistik.kz", avatarPath: "public/albert.einstein.jpg", locale: Locale.current.identifier, currency: "CHF", fullName: PersonNameComponents(givenName: "Albert", familyName: "Einstein")),
                Contact(id: "4", email: "richard.feynman@bolistik.kz", avatarPath: "public/richard.feynman.jpg", locale: Locale.current.identifier, currency: "USD", fullName: PersonNameComponents(givenName: "Richard", familyName: "Feynman")),
                Contact(id: "5", email: "isaac.newton@bolistik.kz", avatarPath: "public/isaac.newton.jpg", locale: Locale.current.identifier, currency: "GBP", fullName: PersonNameComponents(givenName: "Isaac", familyName: "Newton")),
                Contact(id: "6", email: "charles.darwin@bolistik.kz", avatarPath: "public/charles.darwin.jpg", locale: Locale.current.identifier, currency: "AUD", fullName: PersonNameComponents(givenName: "Charles", familyName: "Darwin")),
                Contact(id: "7", email: "michael.faraday@bolistik.kz", avatarPath: "public/michael.faraday.jpg", locale: Locale.current.identifier, currency: "CAD", fullName: PersonNameComponents(givenName: "Michael", familyName: "Faraday")),
                Contact(id: "8", email: "lise.meitner@bolistik.kz", avatarPath: "public/lise.meitner.jpg", locale: Locale.current.identifier, currency: "SEK", fullName: PersonNameComponents(givenName: "Lise", familyName: "Meitner"))
            ]
        ),
        ExpenseGroup(
            imageURL: URL(string: "https://c.pxhere.com/photos/0f/d5/sunset_france_dordogne_bordeaux_countryside_europe_landscape_french-1323550.jpg!d")!,
            name: "Road trip with Friends",
            type: "trip",
            members: [
                Contact(id: "1", email: "marie.curie@bolistik.kz", avatarPath: "public/marie.curie.jpg", locale: Locale.current.identifier, currency: "USD", fullName: PersonNameComponents(givenName: "Marie", familyName: "Curie")),
                Contact(id: "2", email: "nikola.tesla@bolistik.kz", avatarPath: "public/nikola.tesla.jpg", locale: Locale.current.identifier, currency: "EUR", fullName: PersonNameComponents(givenName: "Nikola", familyName: "Tesla")),
                Contact(id: "3", email: "albert.einstein@bolistik.kz", avatarPath: "public/albert.einstein.jpg", locale: Locale.current.identifier, currency: "CHF", fullName: PersonNameComponents(givenName: "Albert", familyName: "Einstein")),
                Contact(id: "4", email: "richard.feynman@bolistik.kz", avatarPath: "public/richard.feynman.jpg", locale: Locale.current.identifier, currency: "USD", fullName: PersonNameComponents(givenName: "Richard", familyName: "Feynman"))
            ]
        ),
        ExpenseGroup(
            imageURL: URL(string: "https://www.soprovich.com/i-28f8046e/real-estate/d82_0085.luxury-lg.default.jpg")! ,
            name: "Family expenses",
            type: "home",
            members: [
                Contact(id: "1", email: "marie.curie@bolistik.kz", avatarPath: "public/marie.curie.jpg", locale: Locale.current.identifier, currency: "USD", fullName: PersonNameComponents(givenName: "Marie", familyName: "Curie")),
                Contact(id: "2", email: "nikola.tesla@bolistik.kz", avatarPath: "public/nikola.tesla.jpg", locale: Locale.current.identifier, currency: "EUR", fullName: PersonNameComponents(givenName: "Nikola", familyName: "Tesla"))
            ]
        )
    ]
}
