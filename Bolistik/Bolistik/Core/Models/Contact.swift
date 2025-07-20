//
//  Contact.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 27.01.25.
//

import Foundation

struct Contact: FirestoreModel {
    
    // MARK: - Public Properties
    
    var id: String
    var locale: String
    var email: String
    var avatarPath: String?
    var currency: String
    
    var displayName: String {
        get {
            guard let fullName = fullName else {
                return ""
            }
            return PersonNameComponentsFormatter().string(from: fullName)
        }
        set {
            let formatter = PersonNameComponentsFormatter()
            if let newFullName = formatter.personNameComponents(from: newValue) {
                self.fullName = newFullName
            }
        }
    }
    
    var isFavorite: Bool = false
    
    init(id: String, email: String?, avatarPath: String?, locale: String, currency: String?, fullName: PersonNameComponents?) {
        self.id = id
        self.email = email ?? ""
        self.avatarPath = avatarPath
        self.locale = locale
        self.currency = currency ?? "EUR"
        self.fullName = fullName
    }
    
    // MARK: - Public Functions
    
    // MARK: - Private Properties
    
    private var givenName: String?
    private var middleName: String?
    private var familyName: String?
    
    private var fullName: PersonNameComponents? {
        get {
            var components = PersonNameComponents()
            components.givenName = givenName
            components.middleName = middleName
            components.familyName = familyName
            return components
        }
        set {
            givenName = newValue?.givenName
            middleName = newValue?.middleName
            familyName = newValue?.familyName
        }
    }
    
}

// MARK: - Codable Implementation

extension Contact {
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case avatarPath
        case locale
        case currency
        case givenName
        case middleName
        case familyName
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(email.isEmpty ? nil : email, forKey: .email)
        try container.encode(avatarPath, forKey: .avatarPath)
        try container.encode(locale, forKey: .locale)
        try container.encode(currency, forKey: .currency)
        try container.encode(givenName, forKey: .givenName)
        try container.encode(middleName, forKey: .middleName)
        try container.encode(familyName, forKey: .familyName)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.avatarPath = try container.decodeIfPresent(String.self, forKey: .avatarPath)
        self.locale = try container.decode(String.self, forKey: .locale)
        self.currency = try container.decode(String.self, forKey: .currency)
        self.givenName = try container.decodeIfPresent(String.self, forKey: .givenName)
        self.middleName = try container.decodeIfPresent(String.self, forKey: .middleName)
        self.familyName = try container.decodeIfPresent(String.self, forKey: .familyName)
    }
}

// MARK: - Samples

extension Contact {
    static let samples = [
        Contact(id: "1", email: "marie.curie@bolistik.kz", avatarPath: "public/marie.curie.jpg", locale: Locale.current.identifier, currency: "USD", fullName: PersonNameComponents(givenName: "Marie", familyName: "Curie")),
        Contact(id: "2", email: "nikola.tesla@bolistik.kz", avatarPath: "public/nikola.tesla.jpg", locale: Locale.current.identifier, currency: "EUR", fullName: PersonNameComponents(givenName: "Nikola", familyName: "Tesla")),
        Contact(id: "3", email: "albert.einstein@bolistik.kz", avatarPath: "public/albert.einstein.jpg", locale: Locale.current.identifier, currency: "CHF", fullName: PersonNameComponents(givenName: "Albert", familyName: "Einstein")),
        Contact(id: "4", email: "richard.feynman@bolistik.kz", avatarPath: "public/richard.feynman.jpg", locale: Locale.current.identifier, currency: "USD", fullName: PersonNameComponents(givenName: "Richard", familyName: "Feynman")),
        Contact(id: "5", email: "isaac.newton@bolistik.kz", avatarPath: "public/isaac.newton.jpg", locale: Locale.current.identifier, currency: "GBP", fullName: PersonNameComponents(givenName: "Isaac", familyName: "Newton")),
        Contact(id: "6", email: "charles.darwin@bolistik.kz", avatarPath: "public/charles.darwin.jpg", locale: Locale.current.identifier, currency: "AUD", fullName: PersonNameComponents(givenName: "Charles", familyName: "Darwin")),
        Contact(id: "7", email: "michael.faraday@bolistik.kz", avatarPath: "public/michael.faraday.jpg", locale: Locale.current.identifier, currency: "CAD", fullName: PersonNameComponents(givenName: "Michael", familyName: "Faraday")),
        Contact(id: "8", email: "lise.meitner@bolistik.kz", avatarPath: "public/lise.meitner.jpg", locale: Locale.current.identifier, currency: "SEK", fullName: PersonNameComponents(givenName: "Lise", familyName: "Meitner"))
    ]
}
