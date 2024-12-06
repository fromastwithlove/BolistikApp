//
//  AuthViewModel.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 05.12.24.
//

import Foundation
import AuthenticationServices

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String? = nil

    private let appleIDProvider = ASAuthorizationAppleIDProvider()

    func checkCredentialState() {
        guard let currentUserID = KeychainItem.currentUserID else {
            isAuthenticated = false
            return
        }

        appleIDProvider.getCredentialState(forUserID: currentUserID) { [weak self] (credentialState, error) in
            switch credentialState {
            case .authorized:
                self?.isAuthenticated = true
                break
            case .revoked, .notFound:
                self?.isAuthenticated = false
                KeychainItem.deleteUserIDFromKeychain()
                break
            default:
                break
            }
        }
    }

    func signInWithApple(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                let userID = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email
                
                print("User ID: \(userID)")
                print("Full Name: \(String(describing: fullName))")
                print("Email: \(String(describing: email))")
//                self.saveUserInKeychain(userID)
                self.isAuthenticated = true
            }
        case .failure(let error):
            self.errorMessage = error.localizedDescription
        }
    }
    
    private func saveUserInKeychain(_ userID: String) {
        do {
            try KeychainItem(account: KeychainKeys.userID).saveItem(userID)
        } catch {
            print("Unable to save userID to keychain.")
        }
    }
}
