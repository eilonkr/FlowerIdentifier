//
//  PlantChatModel.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 02/12/2023.
//

import Foundation

@MainActor class PlantChatModel: ObservableObject {
    let identificationResponse: IdentificationResponse
    private let gptService: GPTServiceProtocol = GPTService()
    
    @Published private(set) var chatItems = [ChatItem]()
    @Published private(set) var isLoadingResponse = false
    
    init(identificationResponse: IdentificationResponse) {
        self.identificationResponse = identificationResponse
    }
    
    // MARK: - Public
    func send(_ text: String) {
        let message = ChatMessage(text: text, sentBy: .user)
        chatItems.append(.message(message))
        isLoadingResponse = true
        
        Task {
            try? await Task.sleep(for: .seconds(0.5))
            chatItems.append(.loader)
        }
        
        Task {
            await send(input: message.text)
        }
    }
    
    // MARK: - Private
    private func send(input: String) async {
        let adjustedInput = "Provide the necessary info for the following request about \(identificationResponse.commonName) (\(identificationResponse.scientificName):\n\(input)"
        
        defer {
            isLoadingResponse = false
        }
        do {
            let result = try await gptService.sendChatMessage(text: adjustedInput,
                                                              model: .model3_5,
                                                              temperature: 0.5)
            let responseMessage = ChatMessage(text: result, sentBy: .ai)
            chatItems[chatItems.count - 1] = .message(responseMessage)
        } catch {
            print(error)
        }
    }
}
