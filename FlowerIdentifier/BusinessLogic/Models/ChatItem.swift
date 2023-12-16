//
//  ChatItem.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 02/12/2023.
//

import Foundation

enum ChatItem: Hashable {
    case message(ChatMessage)
    case loader
    
    var id: String {
        return switch self {
        case .message(let chatMessage):
            chatMessage.id.uuidString
        case .loader:
            "loader"
        }
    }
}
