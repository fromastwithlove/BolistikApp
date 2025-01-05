//
//  Contact.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 26.12.24.
//

import Foundation

struct Contact: Identifiable, Codable {
    var id = UUID()
    var imageUrl: String
    var fullName: PersonNameComponents
    var email: String
    var isFavourite: Bool
    
    init(imageUrl: String, fullName: PersonNameComponents, email: String, isFavourite: Bool = false) {
        self.imageUrl = imageUrl
        self.fullName = fullName
        self.email = email
        self.isFavourite = isFavourite
    }
    
    public var formattedFullName: String {
        let formatter = PersonNameComponentsFormatter()
        return formatter.string(from: fullName)
    }
    
    static let samples = [
        Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/c/c8/Marie_Curie_c._1920s.jpg", fullName: PersonNameComponents(givenName: "Marie", familyName: "Curie"), email: "marie.curie@bolistik.kz"),
        Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/7/79/Tesla_circa_1890.jpeg", fullName: PersonNameComponents(givenName: "Nikola", familyName: "Tesla"), email: "nikola.tesla@bolistik.kz"),
        Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/3/3e/Einstein_1921_by_F_Schmutzer_-_restoration.jpg", fullName: PersonNameComponents(givenName: "Albert", familyName: "Einstein"), email: "albert.einstein@bolistik.kz"),
        Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/en/4/42/Richard_Feynman_Nobel.jpg", fullName: PersonNameComponents(givenName: "Richard", familyName: "Feynman"), email: "richard.feynman@bolistik.kz"),
        Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/f/f7/Portrait_of_Sir_Isaac_Newton%2C_1689_%28brightened%29.jpg", fullName: PersonNameComponents(givenName: "Isaac", familyName: "Newton"), email: "isaac.newton@bolistik.kz"),
        Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/2/2e/Charles_Darwin_seated_crop.jpg", fullName: PersonNameComponents(givenName: "Charles", familyName: "Darwin"), email: "charles.darwin@bolistik.kz"),
        Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/7/7e/Michael_Faraday_sitting_crop.jpg", fullName: PersonNameComponents(givenName: "Michael", familyName: "Faraday"), email: "michael.faraday@bolistik.kz"),
        Contact(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/3/3d/Lise_Meitner.tif", fullName: PersonNameComponents(givenName: "Lise", familyName: "Meitner"), email: "lise.meitner@bolistik.kz")
    ]
}
