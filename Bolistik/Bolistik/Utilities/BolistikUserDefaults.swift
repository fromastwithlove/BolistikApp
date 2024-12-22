//
//  BolistikUserDefaults.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 15.12.24.
//

import Foundation

struct BolistikUserDefaults {
    
    private enum Keys {
        static let fullName = "fullName"
        static let email = "email"
        static let token = "token"
    }

    // MARK: - Full Name
    static var fullName: PersonNameComponents? {
        get {
            guard let data = UserDefaults.standard.data(forKey: Keys.fullName) else { return nil }
            return try? JSONDecoder().decode(PersonNameComponents.self, from: data)
        }
        set {
            if let newValue = newValue {
                let data = try? JSONEncoder().encode(newValue)
                UserDefaults.standard.set(data, forKey: Keys.fullName)
            } else {
                UserDefaults.standard.removeObject(forKey: Keys.fullName)
            }
        }
    }

    // MARK: - Email
    static var email: String? {
        get {
            UserDefaults.standard.string(forKey: Keys.email)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.email)
        }
    }

    // MARK: - Token
    static var token: String? {
        get {
            UserDefaults.standard.string(forKey: Keys.token)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.token)
        }
    }

    // MARK: - Clear token
    static func clearToken() {
        UserDefaults.standard.removeObject(forKey: Keys.token)
    }
}
