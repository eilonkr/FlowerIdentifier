//
//  ChatTip.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 02/12/2023.
//

import SwiftUI
import TipKit

@available(iOS 17, *)
struct ChatTip: Tip {
    var title: Text {
        Text("New: AI Chat")
            .foregroundStyle(Color.title)
            .fontDesign(.rounded)
    }
    
    var message: Text? {
        Text("Ask our AI assistant anything about this or any plant.")
            .foregroundStyle(Color.subtitle)
            .fontDesign(.rounded)
    }
    
    var options: [TipOption] {
        MaxDisplayCount(1)
    }
}
