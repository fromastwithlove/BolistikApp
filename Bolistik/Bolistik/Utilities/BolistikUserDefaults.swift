//
//  BolistikUserDefaults.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 15.12.24.
//

import Foundation

struct BolistikUserDefaults {
    
    private let userDefaults: UserDefaults

    init(suiteName: String? = Bundle.main.bundleIdentifier) {
        if let suiteName = suiteName, let userDefaults = UserDefaults(suiteName: suiteName) {
            self.userDefaults = userDefaults
        } else {
            self.userDefaults = .standard
        }
    }

    private enum Keys {
        static let fullName = "fullName"
        static let email = "email"
        static let token = "token"
    }

    // MARK: - Full Name
    var fullName: PersonNameComponents? {
        get {
            guard let data = userDefaults.data(forKey: Keys.fullName) else { return nil }
            return try? JSONDecoder().decode(PersonNameComponents.self, from: data)
        }
        set {
            if let newValue = newValue {
                let data = try? JSONEncoder().encode(newValue)
                userDefaults.set(data, forKey: Keys.fullName)
            } else {
                userDefaults.removeObject(forKey: Keys.fullName)
            }
        }
    }

    // MARK: - Email
    var email: String? {
        get {
            userDefaults.string(forKey: Keys.email)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.email)
        }
    }

    // MARK: - Token
    var token: String? {
        get {
            userDefaults.string(forKey: Keys.token)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.token)
        }
    }

    // MARK: - Clear Token
    func clearToken() {
        userDefaults.removeObject(forKey: Keys.token)
    }
}
