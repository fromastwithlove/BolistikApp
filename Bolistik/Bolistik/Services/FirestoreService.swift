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

public enum FirestoreCollections {
    static let userProfiles = "userProfiles"
}

// MARK: - Firestore Service Error

public enum FirestoreServiceError: LocalizedError {
    case encodingFailed
    case decodingFailed
    case networkError(Error)
    
    public var errorDescription: String? {
        switch self  {
        case .encodingFailed:
            return NSLocalizedString("error.firestore.encodingFailed", comment: "Error: Failed to encode data before saving to Firestore.")
        case .decodingFailed:
            return NSLocalizedString("error.firestore.decodingFailed", comment: "Error: Failed to decode data from Firestore.")
        case .networkError(let error):
            return String(format: NSLocalizedString("error.firestore.network", comment: "Error: A network issue occurred."), error.localizedDescription)
        }
    }
}

// MARK: - Firestore Service

actor FirestoreService {
    
    // MARK: - Private Properties
    
    private let logger = AppLogger(category: "Firestore")
    private let firestore = Firestore.firestore()
    
    // MARK: - Public Methods
    
    public func userProfileExists(userID: String) async throws -> Bool {
        return try await documentExists(documentId: userID, collection: FirestoreCollections.userProfiles)
    }
    
    public func getUserProfile(userID: String) async throws -> UserProfile? {
        return try await fetch(documentId: userID, collection: FirestoreCollections.userProfiles)
    }
    
    public func saveUserProfile(userID: String, email: String?, avatarPath: String?, fullName: PersonNameComponents?) async throws {
        let userProfile = UserProfile(id: userID,
                                      email: email,
                                      avatarPath: avatarPath,
                                      locale: Locale.current.identifier,
                                      currency: Locale.current.currency?.identifier,
                                      fullName: fullName)
        do {
            try await save(model: userProfile, collection: FirestoreCollections.userProfiles, documentId: userID)
            logger.debug("Successfully saved user profile for id: \(userID) in collection [\(FirestoreCollections.userProfiles)]")
        } catch {
            logger.error("Failed to save user profile: \(error.localizedDescription)")
            throw FirestoreServiceError.networkError(error)
        }
    }
    
    public func updateUserProfile(userID: String, userProfile: UserProfile) async throws {
        do {
            try await save(model: userProfile, collection: FirestoreCollections.userProfiles, documentId: userID)
            logger.debug("Successfully updated user profile for id: \(userID) in collection [\(FirestoreCollections.userProfiles)]")
        } catch {
            logger.error("Failed to update user profile: \(error.localizedDescription)")
            throw FirestoreServiceError.networkError(error)
        }
    }
    
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
