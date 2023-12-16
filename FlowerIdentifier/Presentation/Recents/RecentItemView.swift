//
//  RecentItemView.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthamer on 03/12/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecentItemView: View {
    let recentItem: RecentItem
    let action: () -> Void
    
    private var imageData: RemoteImageData? {
        return recentItem.imageData.first
    }
    
    private var identificationResponse: IdentificationResponse {
        return recentItem.identificationResponse
    }
    
    var body: some View {
        Button(action: action, label: label)
    }
    
    // MARK: - Private
    private func label() -> some View {
        VStack(spacing: 0) {
            image()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(identificationResponse.commonName)
                    .font(.system(.headline, design: .rounded))
                
                Text(identificationResponse.scientificName)
                    .font(.system(.callout, design: .serif))
            }
            .foregroundStyle(Color.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
        }
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(style: .large, strokeColor: Color.separator, strokeWidth: 1)
    }
    
    private func image() -> some View {
        WebImage(url: imageData?.url, context: [.imageThumbnailPixelSize: targetThumbnailSize()])
            .resizable()
            .placeholder {
                Rectangle()
                    .background(Color(.quaternarySystemFill))
            }
            .aspectRatio(contentMode: .fill)
            .scaledToFill(aspectRatio: 2.5)
    }
    
    // MARK: - Private
    private func targetThumbnailSize() -> CGSize {
        var targetImageSize = CGSize()
        if let imageData {
            let targetWidth = min(imageData.width, (UIScreen.main.bounds.width * 0.9) * UIScreen.main.scale)
            targetImageSize = CGSize(width: targetWidth, height: targetWidth / imageData.aspectRatio)
        }
        
        return targetImageSize
    }
}
