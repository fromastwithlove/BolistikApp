//
//  BolistikUserDefaults.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 15.12.24.
//

import Foundation

extension UserDefaults {
    
    private enum Keys {
        static let fullName = "fullName"
        static let email = "email"
        static let token = "token"
        static let baseURL = "baseURL"
    }

    // MARK: - Full Name
    var fullName: PersonNameComponents? {
        get {
            guard let data = self.data(forKey: Keys.fullName) else { return nil }
            return try? JSONDecoder().decode(PersonNameComponents.self, from: data)
        }
        set {
            if let newValue = newValue {
                let data = try? JSONEncoder().encode(newValue)
                self.set(data, forKey: Keys.fullName)
            } else {
                self.removeObject(forKey: Keys.fullName)
            }
        }
    }

    // MARK: - Email
    var email: String? {
        get {
            self.string(forKey: Keys.email)
        }
        set {
            self.set(newValue, forKey: Keys.email)
        }
    }

    // MARK: - Token
    var token: String? {
        get {
            self.string(forKey: Keys.token)
        }
        set {
            self.set(newValue, forKey: Keys.token)
        }
    }

    // MARK: - Clear Token
    func clearToken() {
        self.removeObject(forKey: Keys.token)
    }
    
    // MARK: - Network Base URL
    var baseURL: String? {
        get {
            self.string(forKey: Keys.baseURL)
        }
        set {
            self.set(newValue, forKey: Keys.baseURL)
        }
    }
}
