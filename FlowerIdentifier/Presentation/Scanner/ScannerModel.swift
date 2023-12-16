//
//  ScannerModel.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 28/11/2023.
//

import SwiftUI

@MainActor class ScannerModel: ObservableObject {
    enum CurrentImage: Equatable {
        case cameraPreview(Image)
        case readyForIdentification(PhotoData)
        
        var thumbnailImage: Image {
            return switch self {
            case .cameraPreview(let image):
                image
            case .readyForIdentification(let photoData):
                photoData.thumbnailImage
            }
        }
        
        var aspectRatio: CGFloat {
            return switch self {
            case .cameraPreview:
                Constants.Camera.photoAspectRatio
            case .readyForIdentification(let photoData):
                photoData.imageSize.width / photoData.imageSize.height
            }
        }
        
        var isReadyForIdentification: Bool {
            if case .readyForIdentification = self {
                return true
            }
            
            return false
        }
        
        // Does not check internal image equality
        static func == (lhs: CurrentImage, rhs: CurrentImage) -> Bool {
            switch (lhs, rhs) {
            case (.cameraPreview, .cameraPreview):
                return true
            case (.readyForIdentification, .readyForIdentification):
                return true
            default:
                return false
            }
        }
    }
    
    @Published var currentImage: CurrentImage?
}
