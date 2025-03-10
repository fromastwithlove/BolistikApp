//
//  UserProfile.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 27.01.25.
//

import FirebaseAuth

struct UserProfile: FirestoreModel {
    let uid: String
    let email: String
    
    var fullName: PersonNameComponents?
    
    var locale: String
    var currency: String?
}

// MARK: - Codable Implementation

extension UserProfile {
    enum CodingKeys: String, CodingKey {
        case uid
        case email
        case fullName
        case locale
        case currency
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(email, forKey: .email)
        try container.encode(fullName?.formatted(), forKey: .fullName)
        try container.encode(locale, forKey: .locale)
        try container.encodeIfPresent(currency, forKey: .currency)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uid = try container.decode(String.self, forKey: .uid)
        self.email = try container.decode(String.self, forKey: .email)
        if let fullNameString = try container.decodeIfPresent(String.self, forKey: .fullName) {
            self.fullName = PersonNameComponentsFormatter().personNameComponents(from: fullNameString)
        }
        self.locale = try container.decode(String.self, forKey: .locale)
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency)
    }
}
