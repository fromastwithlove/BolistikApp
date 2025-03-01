//
//  FirestoreService.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 02.02.25.
//

import FirebaseFirestore

// MARK: - Firestore Model Protocol

protocol FirestoreModel: Codable, Sendable {}

// MARK: - Firestore Collections Enum

public enum FirestoreCollections {
    static let userProfiles = "userProfiles"
}

// MARK: - Firestore Service Error

public enum FirestoreServiceError: LocalizedError {
    case encodingFailed
    case decodingFailed
    case documentNotFound
    case networkError(Error)
    
    public var errorDescription: String? {
        switch self  {
        case .encodingFailed:
            return NSLocalizedString("error.firestore.encodingFailed", comment: "Error: Failed to encode data before saving to Firestore.")
        case .decodingFailed:
            return NSLocalizedString("error.firestore.decodingFailed", comment: "Error: Failed to decode data from Firestore.")
        case .documentNotFound:
            return NSLocalizedString("error.firestore.documentNotFound", comment: "Error: The requested document was not found.")
        case .networkError(let error):
            return String(format: NSLocalizedString("error.firestore.network", comment: "Error: A network issue occurred."), error.localizedDescription)
        }
    }
}

// MARK: - Firestore Service

actor FirestoreService {
    
    // MARK: Private Properties
    
    private let logger = AppLogger(category: "Firestore")
    private let firestore = Firestore.firestore()
    
    // MARK: Public Methods
     
    func save<T: FirestoreModel>(_ model: T, inCollection collection: String, withDocumentId documentId: String) async throws {
        let documentRef = firestore.collection(collection).document(documentId)
        
        do {
            let data = try Firestore.Encoder().encode(model)
            
            // Use `merge: true` to update only necessary fields and prevent overwriting existing data
            try await documentRef.setData(data, merge: true)
            
            logger.debug("Successfully saved document [\(documentId)] in collection [\(collection)]")
        } catch let encodingError as EncodingError {
            logger.error("Encoding error while saving document [\(documentId)] in collection [\(collection)]: \(encodingError)")
            throw FirestoreServiceError.encodingFailed
        } catch {
            logger.error("Failed to save document [\(documentId)] in collection [\(collection)]: \(error.localizedDescription)")
            throw FirestoreServiceError.networkError(error)
        }
    }
    
    func fetch<T: FirestoreModel>(_ documentId: String, fromCollection collection: String) async throws -> T? {
        let documentRef = firestore.collection(collection).document(documentId)
        
        do {
            let documentSnapshot = try await documentRef.getDocument()
            
            guard documentSnapshot.exists else {
                logger.debug("Document [\(documentId)] not found in collection [\(collection)]")
                return nil
            }
            
            let model = try documentSnapshot.data(as: T.self)
            logger.info("Successfully fetched document [\(documentId)] from collection [\(collection)]")
            return model
        } catch {
            logger.error("Failed to fetch document [\(documentId)] from collection [\(collection)]: \(error.localizedDescription)")
            throw FirestoreServiceError.networkError(error)
        }
    }
}
