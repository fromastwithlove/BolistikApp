//
//  Contact.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 26.12.24.
//

import Foundation

struct Contact: Identifiable, Codable {
    var id = UUID()

    var avatarPath: String
    var fullName: PersonNameComponents
    var email: String
    var isFavorite: Bool
    
    init(avatarPath: String, fullName: PersonNameComponents, email: String, isFavorite: Bool = false) {
        self.avatarPath = avatarPath
        self.fullName = fullName
        self.email = email
        self.isFavorite = isFavorite
    }
    
    public var formattedFullName: String {
        get {
            let formatter = PersonNameComponentsFormatter()
            return formatter.string(from: fullName)
        }
        set {
            let formatter = PersonNameComponentsFormatter()
            if let components = formatter.personNameComponents(from: newValue) {
                fullName = components
            } else {
                print("Error: Unable to parse formattedFullName into PersonNameComponents") //FIXME: Use logger
            }
        }
    }
    
    static let samples = [
        Contact(avatarPath: "public/marie.curie.jpg", fullName: PersonNameComponents(givenName: "Marie", familyName: "Curie"), email: "marie.curie@bolistik.kz"),
        Contact(avatarPath: "public/nikola.tesla.jpg", fullName: PersonNameComponents(givenName: "Nikola", familyName: "Tesla"), email: "nikola.tesla@bolistik.kz"),
        Contact(avatarPath: "public/albert.einstein.jpg", fullName: PersonNameComponents(givenName: "Albert", familyName: "Einstein"), email: "albert.einstein@bolistik.kz"),
        Contact(avatarPath: "public/richard.feynman.jpg", fullName: PersonNameComponents(givenName: "Richard", familyName: "Feynman"), email: "richard.feynman@bolistik.kz"),
        Contact(avatarPath: "public/isaac.newton.jpg", fullName: PersonNameComponents(givenName: "Isaac", familyName: "Newton"), email: "isaac.newton@bolistik.kz"),
        Contact(avatarPath: "public/charles.darwin.jpg", fullName: PersonNameComponents(givenName: "Charles", familyName: "Darwin"), email: "charles.darwin@bolistik.kz"),
        Contact(avatarPath: "public/michael.faraday.jpg", fullName: PersonNameComponents(givenName: "Michael", familyName: "Faraday"), email: "michael.faraday@bolistik.kz"),
        Contact(avatarPath: "public/lise.meitner.jpg", fullName: PersonNameComponents(givenName: "Lise", familyName: "Meitner"), email: "lise.meitner@bolistik.kz")
    ]
}
