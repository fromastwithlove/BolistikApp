//
//  FirestoreService.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 02.02.25.
//

import FirebaseFirestore

// MARK: - Firestore Model Protocol

protocol FirestoreModel: Codable, Identifiable, Sendable, Equatable {}

// MARK: - Firestore Collections Enum

enum FirestoreCollections {
    static let contacts = "contacts"
}

// MARK: - Firestore Service

actor FirestoreService {
    
    // MARK: - Private Properties
    
    private let logger = AppLogger(category: "Firestore")
    private let firestore = Firestore.firestore()
    
    // MARK: - Private Methods
    
    private func save<T: FirestoreModel>(model: T, collection: String, documentId: String) async throws {
        let documentRef = firestore.collection(collection).document(documentId)
        
        do {
            let data = try Firestore.Encoder().encode(model)
            
            // Use `merge: true` to update only necessary fields and prevent overwriting existing data
            try await documentRef.setData(data, merge: true)
        } catch let encodingError as EncodingError {
            logger.error("Encoding error while saving document [\(documentId)] in collection [\(collection)]: \(encodingError)")
            throw FirestoreServiceError.encodingFailed
        } catch {
            logger.error("Failed to save/update document [\(documentId)] in collection [\(collection)]: \(error.localizedDescription)")
            throw FirestoreServiceError.networkError(error)
        }
    }
    
    private func fetch<T: FirestoreModel>(documentId: String, collection: String) async throws -> T? {
        let documentRef = firestore.collection(collection).document(documentId)
        
        do {
            let documentSnapshot = try await documentRef.getDocument()
            
            guard documentSnapshot.exists else {
                logger.debug("Document [\(documentId)] not found in collection [\(collection)]")
                return nil
            }
            
            let model = try documentSnapshot.data(as: T.self)
            return model
        } catch {
            logger.error("Failed to fetch document [\(documentId)] from collection [\(collection)]: \(error.localizedDescription)")
            throw FirestoreServiceError.networkError(error)
        }
    }
    
    private func documentExists(documentId: String, collection: String) async throws -> Bool {
        let documentRef = firestore.collection(collection).document(documentId)

        do {
            let documentSnapshot = try await documentRef.getDocument()
            return documentSnapshot.exists
        } catch {
            logger.error("Failed to fetch document [\(documentId)] from collection [\(collection)]: \(error.localizedDescription)")
            throw FirestoreServiceError.networkError(error)
        }
    }
}

extension FirestoreService: FirestoreServiceProtocol {
    
    // MARK: - Contact Methods
    
    func contactExists(id: String) async throws -> Bool {
        return try await documentExists(documentId: id, collection: FirestoreCollections.contacts)
    }
    
    func getContact(id: String) async throws -> Contact? {
        return try await fetch(documentId: id, collection: FirestoreCollections.contacts)
    }
    
    func saveContact(id: String, email: String?, avatarPath: String?, fullName: PersonNameComponents?) async throws {
        let contact = Contact(id: id,
                                      email: email,
                                      avatarPath: avatarPath,
                                      locale: Locale.current.identifier,
                                      currency: Locale.current.currency?.identifier,
                                      fullName: fullName)
        do {
            try await save(model: contact, collection: FirestoreCollections.contacts, documentId: id)
            logger.debug("Successfully saved current user contact for id: \(id) in collection [\(FirestoreCollections.contacts)]")
        } catch {
            logger.error("Failed to save current user contact: \(error.localizedDescription)")
            throw FirestoreServiceError.networkError(error)
        }
    }
    
    func updateContact(id: String, contact: Contact) async throws {
        do {
            try await save(model: contact, collection: FirestoreCollections.contacts, documentId: id)
            logger.debug("Successfully updated current user contact for id: \(id) in collection [\(FirestoreCollections.contacts)]")
        } catch {
            logger.error("Failed to update current user contact: \(error.localizedDescription)")
            throw FirestoreServiceError.networkError(error)
        }
    }
}
