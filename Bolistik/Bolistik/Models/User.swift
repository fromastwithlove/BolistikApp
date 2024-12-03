//
//  User.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 03.12.24.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    let email: String
    let username: String
    let token: String
}
