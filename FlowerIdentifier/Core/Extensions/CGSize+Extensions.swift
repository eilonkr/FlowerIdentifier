//
//  CGSize+Extensions.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 30/11/2023.
//

import Foundation

extension CGSize {
    func reversed() -> CGSize {
        return CGSize(width: height, height: width)
    }
}
