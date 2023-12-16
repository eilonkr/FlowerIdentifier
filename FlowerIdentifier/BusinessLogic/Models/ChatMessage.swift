//
//  ChatMessage.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 02/12/2023.
//

import Foundation

struct ChatMessage: Hashable {
    enum SentBy {
        case user
        case ai
    }
    
    let id = UUID()
    let text: String
    let sentBy: SentBy
}
