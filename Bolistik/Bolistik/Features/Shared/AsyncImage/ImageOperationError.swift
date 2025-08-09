//
//  ImageOperationError.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 20.07.25.
//

import Foundation

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
