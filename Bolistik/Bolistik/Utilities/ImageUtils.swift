//
//  ImageUtils.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 05.04.25.
//

import UIKit

class ImageUtils {
    
    static func resizeAndCompressImage(_ image: UIImage, compressionQuality: CGFloat = 0.7) -> Data? {
        let resizedImage = resizeImage(image)
        return compressImage(resizedImage, compressionQuality: compressionQuality)
    }

    private static func resizeImage(_ image: UIImage) -> UIImage {
        let targetSize = CGSize(width: 1024, height: 1024)
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        let newSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }

    private static func compressImage(_ image: UIImage, compressionQuality: CGFloat) -> Data? {
        return image.jpegData(compressionQuality: compressionQuality)
    }
}
