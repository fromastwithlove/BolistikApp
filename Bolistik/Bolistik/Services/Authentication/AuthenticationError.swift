//
//  AuthenticationError.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 13.12.24.
//

import Foundation

/// Enum representing different types of account errors that can occur during account verification.
public enum AuthenticationError: LocalizedError {
    case accountNotFound
    case accountTransferred
    case serverError

    /// A computed property to return a localized error message for each error case.
    public var errorDescription: String? {
        switch self {
        case .accountNotFound:
            return NSLocalizedString("auth.error.message.accountNotFound", comment: "Error: Account not found")
        case .serverError:
            return NSLocalizedString("auth.error.message.serverError", comment: "Error: Server error")
        case .accountTransferred:
            return NSLocalizedString("auth.error.message.accountTransferred", comment: "Error: Account transferred")
        }
    }
}
