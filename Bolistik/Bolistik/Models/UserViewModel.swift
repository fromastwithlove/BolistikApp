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
    
    // MARK: Public
    
    public var formattedEmail: String {
        guard let email = email, !email.isEmpty else { return "" }
        return email
    }
    
    public var formattedFullName: String {
        guard let fullName = fullName else { return "" }
        let formatter = PersonNameComponentsFormatter()
        return formatter.string(from: fullName)
    }
    
    public func fetchUser() {
        Task {
            fullName = await accountService.fullName
            email = await accountService.email
            logger.debug("Fetching user finished")
        }
    }
}
