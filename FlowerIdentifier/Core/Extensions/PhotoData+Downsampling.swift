//
//  PhotoData+Downsampling.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 06/12/2023.
//

import Foundation
import ImageIO

extension PhotoData {
    func downsampledJPEGImageData(maxSize: CGSize) async -> Data {
        let options: [CFString: Any] = [kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
                                        kCGImageSourceCreateThumbnailWithTransform: true,
                                        kCGImageSourceShouldCacheImmediately: true,
                                        kCGImageSourceThumbnailMaxPixelSize: max(maxSize.width, maxSize.height)]
        
        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, options as CFDictionary),
              let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) else {
            return imageData
        }
        
        return image.imageData(for: .jpeg) ?? imageData
    }
}
