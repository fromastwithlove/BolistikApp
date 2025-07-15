//
//  FirestoreServiceProtocol.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 15.07.25.
//

import Foundation

protocol FirestoreServiceProtocol: Sendable {
    
    // MARK: - Profile Methods
    
    func profileExists(id: String) async throws -> Bool
    func getProfile(id: String) async throws -> UserProfile?
    func saveProfile(id: String, email: String?, avatarPath: String?, fullName: PersonNameComponents?) async throws
    func updateProfile(id: String, profile: UserProfile) async throws
}
