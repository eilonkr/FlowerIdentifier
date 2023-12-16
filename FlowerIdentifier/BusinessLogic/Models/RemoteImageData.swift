//
//  RemoteImageData.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 01/12/2023.
//

import Foundation

struct RemoteImageData: Hashable, Codable {
    let url: URL?
    let width: CGFloat
    let height: CGFloat
    
    var aspectRatio: CGFloat {
        return width / height
    }
    
    static func placeholder(aspectRatio: CGFloat) -> RemoteImageData {
        RemoteImageData(url: nil,
                        width: 1,
                        height: aspectRatio)
    }
}
