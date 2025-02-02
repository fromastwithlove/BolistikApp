//
//  InternalUser.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 27.01.25.
//

import Foundation
import FirebaseAuth

struct InternalUser: Sendable {
    let uid: String
    let email: String?
    var displayName: String?
    
    init(from user: User) {
        self.uid = user.uid
        self.email = user.email
        self.displayName = user.displayName
    }
}
