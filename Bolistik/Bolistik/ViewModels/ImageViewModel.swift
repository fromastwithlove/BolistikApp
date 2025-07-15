//
//  ImageViewModel.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 12.03.25.
//

import SwiftUI
import PhotosUI
import CoreTransferable

enum ImageOperationError: Error, LocalizedError {
    case noImageSelected
    case failedToRetrieveImageData
    case failedToConvertToUIImage
    case failedToCompressImage
    case operationFailed(Error)
    case failedToDeleteImage(Error)
    
    var errorDescription: String? {
        switch self {
        case .noImageSelected:
            return "No image was selected for operation."
        case .failedToRetrieveImageData:
            return "Failed to retrieve image data from the selected item."
        case .failedToConvertToUIImage:
            return "Failed to convert image data into a UIImage."
        case .failedToCompressImage:
            return "Failed to compress image data."
        case .operationFailed(let error):
            return "Image operation failed: \(error.localizedDescription)"
        case .failedToDeleteImage(let error):
            return "Image deletion failed: \(error.localizedDescription)"
        }
    }
}

@MainActor
@Observable
class ImageViewModel: ObservableObject {
    
    // MARK: - Public Properties
    
    enum ImageState {
        case empty
        case loading(Progress)
        case success(Image)
        case failure(Error)
    }
    
    // MARK: - Private Properties
    
    private let logger = AppLogger(category: "UI.ImageViewModel")
    private let firebaseStorageService: FirebaseStorageService
    private(set) var imageState: ImageState = .empty
    
    // MARK: - Published Property
    
    init(firebaseStorageService: FirebaseStorageService, imagePath: String?) {
        self.firebaseStorageService = firebaseStorageService
        self.imagePath = imagePath
    }
    
    public var imagePath: String?

    public var imageSelection: PhotosPickerItem? {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }
    
    // MARK: - Public Methods
    
    public func loadImage() async {
        imageState = .loading(Progress())
        guard let path = imagePath, !path.isEmpty else {
            imageState = .empty
            return
        }
        
        do {
            if let fetchedImage = try await firebaseStorageService.fetchImage(path: path) {
                imageState = .success(Image(uiImage: fetchedImage))
            }
        } catch {
            logger.error("Image loading failed: \(error)")
            imageState = .failure(error)
        }
    }
    
    public func uploadImage(path: String) async throws {
        guard let imageSelection else {
            return
        }
        
        do {
            guard let imageData = try await imageSelection.loadTransferable(type: Data.self) else {
                logger.error("Failed to retrieve image data.")
                throw ImageOperationError.failedToRetrieveImageData
            }
            
            try await firebaseStorageService.uploadImage(data: imageData, path: path)
        } catch {
            logger.error("Image upload failed: \(error)")
            throw ImageOperationError.operationFailed(error)
        }
    }
    
    public func deleteImage(path: String) async throws {
        imageState = .loading(Progress())
        
        do {
            try await firebaseStorageService.deleteImage(path: path)
            imageState = .empty
        } catch {
            logger.error("Image deletion failed: \(error)")
            imageState = .failure(error)
            throw ImageOperationError.failedToDeleteImage(error)
        }
    }
    
    // MARK: - Private Methods
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: Image.self) { result in
            Task { @MainActor in
                guard imageSelection == self.imageSelection else {
                    self.logger.error("Failed to load the selected item.")
                    return
                }
                switch result {
                case .success(let image?):
                    self.imageState = .success(image)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
}
