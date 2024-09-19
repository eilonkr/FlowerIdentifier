//
//  GPTModel.swift
//  writeai
//
//  Created by Eilon Krauthammer on 24/06/2023.
//

import Foundation
import ChatGPTSwift

enum GPTModel: String {
    case model3_5 = "gpt-3.5-turbo"
    case model4O = "gpt-4o"
    
    init?(chatGPTSwiftModel: ChatGPTModel) {
        switch chatGPTSwiftModel {
        case .gpt_hyphen_3_period_5_hyphen_turbo:
            self = .model3_5
        case .gpt_hyphen_4o:
            self = .model4O
        default:
            return nil
        }
    }
    
    func toChatGPTSwiftModel() -> ChatGPTModel {
        return switch self {
        case .model3_5:
            .gpt_hyphen_3_period_5_hyphen_turbo
        default:
            .gpt_hyphen_4o
        }
    }
}
