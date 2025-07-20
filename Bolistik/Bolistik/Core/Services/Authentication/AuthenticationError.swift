//
//  AuthenticationError.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 19.07.25.
//

import Foundation

enum AuthenticationError: LocalizedError {
    case accountNotFound
    case accountTransferred
    case serverError
    case missingNonce
    case missingGoogleClientID
    case googleIDTokenIsMissing
    case nameConversionFailed
    
    /// A computed property to return a localized error message for each error case.
    var errorDescription: String? {
        switch self {
            case .accountNotFound:
                return NSLocalizedString("error.auth.accountNotFound", comment: "Error: Account not found")
            case .serverError:
                return NSLocalizedString("error.auth.serverError", comment: "Error: Server error")
            case .accountTransferred:
                return NSLocalizedString("error.auth.accountTransferred", comment: "Error: Account transferred")
            case .missingNonce:
                return NSLocalizedString("error.auth.missingNonce", comment: "Error: Missing nonce")
            case .missingGoogleClientID:
                return NSLocalizedString("error.auth.missingGoogleClientID", comment: "Error: Missing Google client ID")
            case .googleIDTokenIsMissing:
                return NSLocalizedString("error.auth.googleIDTokenIsMissing", comment: "Error: Missing Google ID token")
            case .nameConversionFailed:
                return NSLocalizedString("error.auth.nameConversionFailed", comment: "Error: Failed to convert display name to full name")
        }
    }
}
