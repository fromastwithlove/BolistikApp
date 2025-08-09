//
//  ProfileViewModel.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 03.12.24.
//

import Foundation

@MainActor
@Observable
final class ProfileViewModel: ObservableObject {
    
    // MARK: - Private Properties
    
    private let logger = AppLogger(category: "UI.ProfileViewModel")
    private let profileRepository: ProfileRepositoryProtocol
    private let userID: String
    
    // Regular Expressions for validation
    private let nameRegex = #"^[A-Za-zÀ-ÖØ-öø-ÿ]+(?: [A-Za-zÀ-ÖØ-öø-ÿ]+)*$"#
    private let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    
    init(profileRepository: ProfileRepositoryProtocol, userID: String) {
        self.profileRepository = profileRepository
        self.userID = userID
    }
    
    // MARK: - Published Properties
    
    var currentUser: Contact?
    var contacts: [Contact] = Contact.samples
    var searchText: String = ""
    
    // MARK: - Public Methods
    
    func loadCurrentUser() async {
        do {
            if let existingUser = try await profileRepository.getProfile(id: userID) {
                currentUser = existingUser
            }
            logger.info("Current user loaded successfully")
        } catch {
            logger.error("Failed to load current user contact: \(error)")
        }
    }
    
    func validate(profile: Contact) -> Bool {
        // Check if Display Name matches the expected format (only letters and at least one space between names)
        if !NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: profile.displayName) {
            logger.error("Invalid full name: \(profile.displayName)")
            return false
        }
        
        // Check if Email matches the expected email pattern
        if !NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: profile.email) {
            logger.error("Invalid email format: Please enter a valid email address.")
            return false
        }
        
        return true
    }
    
    func update(profile: Contact) async {
        guard validate(profile: profile) else { return }
        
        // Overwrite the current user locally to reflect changes immediately, since updating Firestore and reloading the current user takes time.
        currentUser = profile
        
        do {
            try await profileRepository.updateProfile(id: userID, contact: profile)
            logger.info("Contact updated successfully")
        } catch {
            logger.error("Failed to updated user contact: \(error.localizedDescription)")
        }
    }
}
