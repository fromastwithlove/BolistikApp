//
//  FirestoreError.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 19.07.25.
//

import Foundation

enum FirestoreServiceError: LocalizedError {
    case encodingFailed
    case decodingFailed
    case networkError(Error)
    
    var errorDescription: String? {
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
