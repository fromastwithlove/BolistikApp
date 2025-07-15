//
//  FirestoreServiceProtocol.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 15.07.25.
//

import Foundation

protocol FirestoreServiceProtocol: Sendable {
    
    // MARK: - Contact Methods
    
    func contactExists(id: String) async throws -> Bool
    func getContact(id: String) async throws -> Contact?
    func saveContact(id: String, email: String?, avatarPath: String?, fullName: PersonNameComponents?) async throws
    func updateContact(id: String, contact: Contact) async throws
}
