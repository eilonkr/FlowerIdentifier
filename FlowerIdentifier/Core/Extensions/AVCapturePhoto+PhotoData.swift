//
//  AVCapturePhoto+Image.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 28/11/2023.
//

import SwiftUI
import AVFoundation

extension AVCapturePhoto {
    func createPhotoData() -> PhotoData? {
        guard let imageData = fileDataRepresentation(),
              let previewCGImage = previewCGImageRepresentation(),
              let metadataOrientation = metadata[String(kCGImagePropertyOrientation)] as? UInt32,
              let cgImageOrientation = CGImagePropertyOrientation(rawValue: metadataOrientation) else {
            return nil
        }
        
        let imageOrientation = Image.Orientation(cgImageOrientation)
        let thumbnailImage = Image(decorative: previewCGImage, scale: 1, orientation: imageOrientation)
        let photoDimensions = resolvedSettings.photoDimensions
        var imageSize = CGSize(width: CGFloat(photoDimensions.width), height: CGFloat(photoDimensions.height))
        let previewDimensions = resolvedSettings.previewDimensions
        var thumbnailSize = CGSize(width: CGFloat(previewDimensions.width), height: CGFloat(previewDimensions.height))
        if cgImageOrientation == .right || cgImageOrientation == .left {
            imageSize = imageSize.reversed()
            thumbnailSize = thumbnailSize.reversed()
        }
        
        return PhotoData(thumbnailImage: thumbnailImage,
                         thumbnailSize: thumbnailSize,
                         imageData: imageData,
                         imageSize: imageSize)
    }
}

