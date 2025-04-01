//
//  FirebaseStorageService.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 11.03.25.
//

import Foundation
import UIKit
import FirebaseStorage

enum FirebaseStoragePath: String {
    case publicFolder = "public"
    case avatarsFolder = "avatars"
    
    var fullPath: String {
        return self.rawValue
    }
}

actor FirebaseStorageService {
    
    // MARK: - Private
    
    private let logger = AppLogger(category: "FirebaseStorage")
    
    // Define a constant for the max image size
    private let maxImageSize: Int64 = 3 * 1024 * 1024
    
    // In-memory cache to store already downloaded images using their storage paths as keys.
    // This helps avoid redundant network calls and improves performance.
    private var cache: [String: UIImage] = [:]

    // MARK: - Public methods
    
    func fetchImage(path: String) async throws -> UIImage? {
        // Check if the image is already cached
        if let cachedImage = cache[path] {
            return cachedImage
        }

        // Fetch the image from Firebase Storage
        let storageRef = Storage.storage().reference().child(path)
        let data = try await storageRef.data(maxSize: maxImageSize)

        // Convert data to UIImage and cache it
        if let image = UIImage(data: data) {
            cache[path] = image
            return image
        }

        return nil
    }
    
    func uploadImage(data: Data, path: String) async throws {
        // Limit the upload size to 3MB
        guard data.count <= maxImageSize else {
            logger.error("Image exceeds the maximum allowed size of 3MB.")
            throw ImageUploadError.exceedsMaxSize
        }
        
        guard let uiImage = UIImage(data: data) else {
            logger.error("Failed to convert image data to UIImage.")
            throw ImageUploadError.failedToConvertToUIImage
        }
        
        // Update the cache
        cache[path] = uiImage
        
        let storageRef = Storage.storage().reference().child(path)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload image
        storageRef.putData(data, metadata: metadata)
        logger.debug("Image uploaded successfully.")
    }
}
