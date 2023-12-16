//
//  CIImage+Image.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 28/11/2023.
//

import SwiftUI

extension CIImage {
    var image: Image? {
        guard let cgImage = CIContext.shared.createCGImage(self, from: extent) else {
            return nil
        }
        
        return Image(decorative: cgImage, scale: 1.0, orientation: .up)
    }
}
