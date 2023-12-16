//
//  WikiService.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 29/11/2023.
//

import Foundation

class WikiService {
    enum WikiError: Error {
        case pageNotFound
    }
    
    static func getImageData(searchTerm: String,
                             allowedFormats: Set<String> = ["jpeg", "jpg", "png"]) async throws -> [RemoteImageData] {
        guard let pageId = try await getPageId(searchTerm: searchTerm) else {
            throw WikiError.pageNotFound
        }
        
        let urls = try await getImageData(pageId: pageId, allowedFormats: allowedFormats)
        
        return urls
    }
    
    static func getPageId(searchTerm: String) async throws -> Int? {
        let url = "https://en.wikipedia.org/w/api.php?action=query&format=json&list=search&srsearch=\(searchTerm)"
        let pageIdResponse: WikiModels.WikiPageIdSearchResult = try await HTTPClient.get(url)
        
        return pageIdResponse.query.search.first?.pageid
    }
    
    static func getImageData(pageId: Int, allowedFormats: Set<String>) async throws -> [RemoteImageData] {
        let url = "https://en.wikipedia.org/w/api.php?action=query&pageids=\(pageId)&generator=images&prop=imageinfo&iiprop=url|dimensions&format=json&gimlimit=500"
        let imageResponse: WikiModels.WikiImageDataResult = try await HTTPClient.get(url)
        
        let imageData = imageResponse.query.pages.sorted { $0.key > $1.key }
            .flatMap { $0.value.imageinfo }
            .compactMap { imageInfo -> RemoteImageData? in
                guard let url = URL(string: imageInfo.url) else {
                    return nil
                }
                
                return RemoteImageData(url: url, width: CGFloat(imageInfo.width), height: CGFloat(imageInfo.height))
            }
            .filter { allowedFormats.contains($0.url!.pathExtension) }
        
        return imageData
    }
    
    private init() { }
}
