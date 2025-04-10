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
    private let maxImageSize: Int64 = 5 * 1024 * 1024
    
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

        // Convert data to UIImage
        guard let image = UIImage(data: data) else {
            return nil
        }

        // Cache and return the image
        cache[path] = image
        return image
    }
    
    func uploadImage(data: Data, path: String) async throws {
        guard let uiImage = UIImage(data: data) else {
            logger.error("Failed to convert image data to UIImage.")
            throw ImageOperationError.failedToConvertToUIImage
        }
        
        // Resize and compress the image
        guard let compressedData = ImageUtils.resizeAndCompressImage(uiImage, compressionQuality: 0.7) else {
            logger.error("Failed to resize and compress image.")
            throw ImageOperationError.failedToCompressImage
        }
        
        // Update the cache
        cache[path] = uiImage
        
        let storageRef = Storage.storage().reference().child(path)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload image
        storageRef.putData(compressedData, metadata: metadata)
        logger.debug("Image uploaded successfully.")
    }
    
    func deleteImage(path: String) async throws {
        // Remove from the cache first
        cache.removeValue(forKey: path)
        
        let storageRef = Storage.storage().reference().child(path)
        try await storageRef.delete()
        logger.debug("Image deleted successfully.")
    }
}
