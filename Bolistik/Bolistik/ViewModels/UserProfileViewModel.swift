//
//  UserProfileViewModel.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 03.12.24.
//

import Foundation

@MainActor
@Observable
final class UserProfileViewModel: ObservableObject {
    
    // MARK: - Private Properties
    
    private let logger = AppLogger(category: "UI.UserProfileViewModel")
    private let firestoreService: FirestoreService
    private let userID: String
    
    // Regular Expressions for validation
    private let nameRegex = #"^[A-Za-zÀ-ÖØ-öø-ÿ]+(?: [A-Za-zÀ-ÖØ-öø-ÿ]+)*$"#
    private let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    
    init(firestoreService: FirestoreService, userID: String) {
        self.firestoreService = firestoreService
        self.userID = userID
    }
    
    // MARK: - Published properties
    
    var userProfile: UserProfile?
    
    // MARK: - Public methods
    
    public func loadUserProfile() async {
        do {
            if let existingProfile = try await firestoreService.getUserProfile(userID: userID) {
                userProfile = existingProfile
            }
            logger.info("User profile loaded successfully")
        } catch {
            logger.error("Failed to load user profile: \(error)")
        }
    }
    
    public func validate(profile: UserProfile) -> Bool {
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
    
    public func update(profile: UserProfile) async {
        guard validate(profile: profile) else { return }
        
        // Overwrite the profile locally to reflect changes immediately, since updating Firestore and reloading the profile takes time.
        userProfile = profile
        
        do {
            try await firestoreService.updateUserProfile(userID: userID, userProfile: profile)
            logger.info("User profile updated successfully")
        } catch {
            logger.error("Failed to updated user profile: \(error.localizedDescription)")
        }
    }
}
