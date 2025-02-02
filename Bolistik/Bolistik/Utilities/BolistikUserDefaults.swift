//
//  BolistikUserDefaults.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 15.12.24.
//

import Foundation

extension UserDefaults {
    
    private enum Keys {
        static let baseURL = "baseURL"
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
