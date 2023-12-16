//
//  CIContext+Shared.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 28/11/2023.
//

import UIKit

fileprivate class CIContextStorage {
    static let shared = CIContextStorage()
    
    private init() { }
    
    lazy var ciContext: CIContext = {
        let options: [CIContextOption: Any] = [.cacheIntermediates: NSNumber(false),
                                               .outputPremultiplied: NSNumber(true),
                                               .useSoftwareRenderer: NSNumber(false),
                                               .highQualityDownsample: NSNumber(true)]

        guard let metalDevice = MTLCreateSystemDefaultDevice() else {
            return CIContext(options: options)
        }

        let context = CIContext(mtlDevice: metalDevice, options: options)
        return context
    }()
}

extension CIContext {
    static let shared = CIContextStorage.shared.ciContext
}
