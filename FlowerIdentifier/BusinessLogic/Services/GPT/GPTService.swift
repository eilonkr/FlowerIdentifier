//
//  GPTService.swift
//  writeai
//
//  Created by Eilon Krauthammer on 27/05/2023.
//

import Foundation
import ChatGPTSwift

class GPTService: GPTServiceProtocol {
    private let apiWrapper = ChatGPTAPIWrapper()
    private var api: ChatGPTAPI {
        get async {
            return await apiWrapper.getAPI()
        }
    }
    
    // MARK: - Public
    func sendChatMessage(text: String,
                         model: GPTModel,
                         temperature: Double) async throws -> String {
        return try await api.sendMessage(text: text,
                                         model: model.toChatGPTSwiftModel(),
                                         systemText: createSystemText(),
                                         temperature: temperature,
                                         maxTokens: 600)
    }
    
    func sendIdentificationMessage(imageInput: ImageInput,
                                   model: GPTModel,
                                   language: String,
                                   temperature: Double) async throws -> IdentificationResponse {
        let response = try await api.sendMessage(text: imageIdentificationPrompt(language: language),
                                                 model: model.toChatGPTSwiftModel(),
                                                 systemText: createSystemText(),
                                                 temperature: temperature,
                                                 imageInput: imageInput)
        print("Identification response:\n\(response)")
        
        let responseData = Data(response.utf8)
        let decodedResponse = try JSONDecoder().decode(IdentificationResponse.self, from: responseData)
        
        return decodedResponse
    }
    
    func sendSearchMessage(searchTerm: String, model: GPTModel, temperature: Double) async throws -> IdentificationResponse {
        let response = try await api.sendMessage(text: searchPrompt(searchTerm: searchTerm),
                                                 model: model.toChatGPTSwiftModel(),
                                                 systemText: createSystemText(),
                                                 temperature: temperature,
                                                 maxTokens: 2000)
        print("Serch response:\n\(response)")
        
        let responseData = Data(response.utf8)
        let decodedResponse = try JSONDecoder().decode(IdentificationResponse.self, from: responseData)
        
        return decodedResponse
    }
    
    // MARK: - Private
    private func imageIdentificationPrompt(language: String) -> String {
        let exampleJSONFileURL = Bundle.main.url(forResource: "ResponseExample", withExtension: "json")!
        let jsonString = try! String(contentsOf: exampleJSONFileURL)
        let prompt = """
        Please identify the following flower or plant, and provide your input with in the following JSON format, replacing the placeholder text with your data:
        \(jsonString)
        Make sure to return the JSON only.
        Include anywhere between 3-7 instructions as you see fit.
        The `health.problems` array is optional, include it only if you detect any, don't include the array at all otherwise. Include up to 3 problems if found.
        For the `scientificName` field - name the concrete species and not multiple species, i.e. no spp.
        Do not include any code formatting.
        Make sure the values of the JSON are in \(language), apart from `health.status`.
        """
        
        print(prompt)
        return prompt
    }
    
    private func searchPrompt(searchTerm: String) -> String {
        let exampleJSONFileURL = Bundle.main.url(forResource: "ResponseExample", withExtension: "json")!
        let jsonString = try! String(contentsOf: exampleJSONFileURL)
        let prompt = """
        Please provide details about the following flower or plant: \(searchTerm). Provide your input with in the following JSON format, replacing the placeholder text with your data:
        \(jsonString)
        Omit the `health` item.
        Make sure to return the JSON only.
        Include anywhere between 3-7 instructions as you see fit.
        Do not include any code formatting.
        """
        
        print(prompt)
        return prompt
    }
    
    private func createSystemText(isChatMessage: Bool = false) -> String {
        var text = """
        You are an helpful assistant with excellent flower and plant identification skills, and your job is to provide accurate flower and plant identification, plant info and care details.
        """
        
        if isChatMessage {
            let chatSystemText = "You are allowed to provide answers only about flowers and plants. If you are asked about different matters, respond that you cannot help with that."
            text.append(" \(chatSystemText)")
        }
        
        return text
    }
}
