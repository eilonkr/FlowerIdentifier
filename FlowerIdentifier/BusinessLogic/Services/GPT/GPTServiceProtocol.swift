//
//  GPTServiceProtocol.swift
//  writeai
//
//  Created by Eilon Krauthammer on 27/05/2023.
//

import Foundation
import ChatGPTSwift

protocol GPTServiceProtocol {
    func sendChatMessage(text: String,
                         model: GPTModel,
                         temperature: Double) async throws -> String
    
    func sendIdentificationMessage(imageInput: ImageInput,
                                   model: GPTModel,
                                   language: String,
                                   temperature: Double) async throws -> IdentificationResponse
}

class GPTServiceResolver {
    static func resolveCurrentService() -> GPTServiceProtocol {
        if UserDefaults.standard.bool(forKey: UserStateSharedKey.mockGPTResponse.rawValue) {
            return GPTMockService()
        }
        
        return GPTService()
    }

    private init() { }
}
