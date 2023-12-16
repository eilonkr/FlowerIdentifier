//
//  SearchModel.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthamer on 03/12/2023.
//

import Foundation

@MainActor class SearchModel: ObservableObject {
    private lazy var gptService = GPTService() //GPTServiceResolver.resolveCurrentService()
    @Published var isSearching = false
    @Published var result: Result<IdentificationResponse, Error>?
    
    func search(_ text: String) {
        isSearching = true
        
        Task {
            defer {
                isSearching = false
            }
            
            do {
                let identificationResponse = try await gptService.sendSearchMessage(searchTerm: text,
                                                                                    model: .model4Turbo,
                                                                                    temperature: 0.5)
                result = .success(identificationResponse)
            } catch {
                print("Search error:\n\(error)")
                result = .failure(error)
            }
        }
    }
}
