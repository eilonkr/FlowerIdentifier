//
//  UIImage+PhotoData.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 30/11/2023.
//

import UIKit
import SwiftUI

extension UIImage {
    func createPhotoData() -> PhotoData? {
        guard let data = jpegData(compressionQuality: 1.0) else {
            return nil
        }
        
        let targetWidth: CGFloat = min(size.width, UIScreen.main.bounds.width * UIScreen.main.scale)
        let scaleFactor = targetWidth / size.width
        let height = size.height * scaleFactor
        let thumbnailSize = CGSize(width: targetWidth, height: height)
        let thumbnailImage = resized(to: thumbnailSize)
        let photoData = PhotoData(thumbnailImage: Image(uiImage: thumbnailImage),
                                  thumbnailSize: thumbnailSize,
                                  imageData: data,
                                  imageSize: size)
        
        return photoData
    }
}
