//
//  UserViewModel.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 03.12.24.
//

import Foundation

@MainActor
@Observable
final class UserViewModel: ObservableObject {
    
    // MARK: Private
    private let logger = AppLogger(category: "UI")
    private let accountService: AccountService
    
    init(accountService: AccountService) {
        self.accountService = accountService
    }
    
    // MARK: Published properties
    
    var isLoading: Bool = false
    var error: LocalizedError?
    var fullName: PersonNameComponents?
    var email: String?
    
    // MARK: Public methods
    
    public func fetchUser() {
        Task {
            fullName = await accountService.fullName
            email = await accountService.email
            logger.debug("Fetching user finished")
        }
    }
    
    public func formattedFullName() -> String {
        guard let fullName = fullName else { return "" }
        
        // Check if both given name and family name are non-empty
        guard let givenName = fullName.givenName, !givenName.isEmpty else {
            // If only the family name is non-empty
            if let familyName = fullName.familyName, !familyName.isEmpty {
                return familyName
            }
            return ""
        }
        
        // If both names are non-empty, return "givenName, familyName"
        if let familyName = fullName.familyName, !familyName.isEmpty {
            return "\(givenName), \(familyName)"
        }
        
        return givenName
    }
    
    public func formattedEmail() -> String {
        guard let email = email, !email.isEmpty else {
            return ""
        }
        return email
    }
}
