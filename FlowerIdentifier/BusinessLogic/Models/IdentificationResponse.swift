//
//  IdentificationResponse.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 28/11/2023.
//

import Foundation

struct IdentificationResponse: Hashable, Codable {
    let commonName: String
    let scientificName: String
    let description: String
    let careInstructions: [String]
    let healthProblems: [String]?
    let temperatureRange: String
    let geography: String
    let sunlight: String
    let rarityIndex: String
    let health: PlantHealth?
    let bloomingSeason: String?
    let uses: [String]?
}
