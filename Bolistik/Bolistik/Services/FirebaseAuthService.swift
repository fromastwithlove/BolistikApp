//
//  FirebaseAuthService.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 23.01.25.
//

import FirebaseAuth
import CryptoKit

final class FirebaseAuthService {
    
    // MARK: Private
    
    private let logger = AppLogger(category: "FirebaseAuth")
    
    // MARK: Public
    
    public var user: User? {
        return Auth.auth().currentUser
    }
    // TODO: Refactor this method
    public func appleUserUID() -> String? {
        let providerData = Auth.auth().currentUser?.providerData
        if let appleProviderData = providerData?.first(where: { $0.providerID == AuthProviderID.apple.rawValue }) {
            return appleProviderData.uid
        }
        return nil
    }
    
    public func signInWith(appleIDToken: String, nonce: String, fullName: PersonNameComponents?) -> Task<InternalUser, Error> {
        logger.debug("Signing in with Firebase using Apple ID")
        
        return Task {
            do {
                let credential = OAuthProvider.appleCredential(withIDToken: appleIDToken, rawNonce: nonce, fullName: fullName)
                let authResult = try await Auth.auth().signIn(with: credential)
                return InternalUser(from: authResult.user)
            } catch {
                throw error
            }
        }
    }
    // TODO: Should this function throw?
    public func updateDisplayName(displayName: String) {
        guard let user = Auth.auth().currentUser, !displayName.isEmpty else {
            return
        }
        
        logger.debug("Updating user's display name to \(displayName) in Firebase.")
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        
        Task {
            do {
                try await changeRequest.commitChanges()
            }
            catch {
                throw error
            }
        }
    }
    
    public func signOut() throws {
        do {
            try Auth.auth().signOut()
            logger.debug("Successfully signed out from Firebase.")
        } catch {
            logger.error("Error signing out from Firebase: \(error.localizedDescription)")
            throw error
        }
    }
}

// MARK: Firebase security requirements

extension FirebaseAuthService {
    
    public func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }

    public func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}
