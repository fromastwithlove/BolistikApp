//
//  ProfileRepository.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 09.08.25.
//

import Foundation

protocol ProfileRepositoryProtocol: Sendable {
    
    // MARK: - Profile Methods
    
    func getProfile(id: String) async throws -> Contact?
    func updateProfile(id: String, contact: Contact) async throws
}

final class ProfileRepository: ProfileRepositoryProtocol {
    
    // MARK: - Private Properties
    
    private let logger = AppLogger(category: "ProfileRepository")
    private let firestoreService: FirestoreServiceProtocol
    
    init(firestoreService: FirestoreServiceProtocol) {
        self.firestoreService = firestoreService
    }
    
    // MARK: - Protocol Methods
    
    func getProfile(id: String) async throws -> Contact? {
        return try await firestoreService.getContact(id: id)
    }
    
    func updateProfile(id: String, contact: Contact) async throws {
        try await firestoreService.updateContact(id: id, contact: contact)
    }
}
