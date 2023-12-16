//
//  PlantInfoModel.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 29/11/2023.
//

import Foundation

@MainActor class PlantInfoModel: ObservableObject {
    let identificationResponse: IdentificationResponse
    private(set) var didFetchRemoteImageData = false
    
    @Published var imageData: [RemoteImageData]
    
    // MARK: - Lifecycle
    init(identificationResponse: IdentificationResponse) {
        self.identificationResponse = identificationResponse
        
        // Setup placeholders
        let aspectRatios: [CGFloat] = [0.75, 1, 0.565, 1.2, 0.9]
        imageData = aspectRatios.map {
            .placeholder(aspectRatio: $0)
        }
    }
    
    init(recentItem: RecentItem) {
        identificationResponse = recentItem.identificationResponse
        imageData = recentItem.imageData
        didFetchRemoteImageData = true
    }
    
    // MARK: - Public
    func fetchImagesIfNeeded() async throws {
        guard didFetchRemoteImageData == false else {
            return
        }
        
        do {
            imageData = try await WikiService.getImageData(searchTerm: identificationResponse.scientificName)
            didFetchRemoteImageData = true
        } catch {
            print("Failed to get image URLs for \(identificationResponse.scientificName):\n\(error)")
        }
    }
}
