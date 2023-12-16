//
//  ProductDisplayItem.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthamer on 07/12/2023.
//

import Foundation

struct ProductDisplayItem: Hashable {
    let productId: String
    let price: Decimal
    let productTitle: String
    let priceTitle: String
    let hasFreeTrial: Bool
    let badge: String?
}
