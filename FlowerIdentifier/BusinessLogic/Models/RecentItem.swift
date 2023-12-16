//
//  RecentItem.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthamer on 03/12/2023.
//

import Foundation

struct RecentItem: LocallyStorable {
    static var storageId: String {
        return "recents"
    }
    
    let identificationResponse: IdentificationResponse
    let imageData: [RemoteImageData]
}
