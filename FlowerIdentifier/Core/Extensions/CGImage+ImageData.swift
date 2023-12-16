//
//  CGImage+ImageData.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 06/12/2023.
//

import UIKit
import UniformTypeIdentifiers

extension CGImage {
    func imageData(for utType: UTType) -> Data? {
        guard let mutableData = CFDataCreateMutable(nil, 0),
              let destination = CGImageDestinationCreateWithData(mutableData, utType.identifier as CFString, 1, nil) else {
            return nil
        }
        
        CGImageDestinationAddImage(destination, self, nil)
        guard CGImageDestinationFinalize(destination) else {
            return nil
        }
        
        return mutableData as Data
    }
}
