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
    
    private let logger = AppLogger(category: "UI")
    private let firestoreService: FirestoreService
    private let userUID: String
    
    // FIXME: Init empty profile?
    private var userProfile = UserProfile(id: "",
                                          email: nil,
                                          avatarPath: nil,
                                          locale: "",
                                          currency: "EUR",
                                          fullName: nil)
    
    init(firestoreService: FirestoreService, userUID: String) {
        self.firestoreService = firestoreService
        self.userUID = userUID
    }
    
    // MARK: - Published properties
    
    var userId: String {
        get {
            return userProfile.id
        }
    }
    
    var avatarPath: String? {
        get {
            return userProfile.avatarPath
        }
        set {
            userProfile.avatarPath = newValue
        }
    }
    
    var displayName: String {
        get {
            return userProfile.displayName
        }
        set {
            userProfile.displayName = newValue
        }
    }
    
    var isDisplayNameValid: Bool {
        let nameRegex = #"^[A-Za-zÀ-ÖØ-öø-ÿ]+(?: [A-Za-zÀ-ÖØ-öø-ÿ]+)+$"#
        return NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: displayName)
    }
    
    var email: String {
        get {
            return userProfile.email ?? ""
        }
        set {
            userProfile.email = newValue
        }
    }
    
    var isEmailValid: Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    var currency: String {
        get {
            return userProfile.currency
        }
        set {
            userProfile.currency = newValue
        }
    }
    
    // MARK: - Public methods
    
    public func loadUserProfile() async {
        do {
            if let existingProfile = try await firestoreService.getUserProfile(userUID: userUID) {
                userProfile = existingProfile
            }
        } catch {
            logger.error("Failed to load user profile: \(error)")
        }
    }
    
    public func validateUserProfile() -> Bool {
        guard isDisplayNameValid else {
            logger.error("Invalid full name")
            return false
        }
        
        guard isEmailValid else {
            logger.error("Invalid email address")
            return false
        }
        
        return true
    }
    
    public func updateUserProfile() async {
        guard validateUserProfile() else { return }
        
        do {
            try await firestoreService.updateUserProfile(userUID: userUID, userProfile: userProfile)
            logger.info("User profile updated successfully")
        } catch {
            logger.error("Failed to updated user profile: \(error.localizedDescription)")
        }
    }
}
