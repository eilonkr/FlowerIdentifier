//
//  PhotoPickerModel.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 28/11/2023.
//

import SwiftUI
import PhotosUI

enum PhotoState {
    case loading
    case loaded(UIImage)
    case failed
}

@MainActor class PhotoPickerModel: ObservableObject {
    @Published var photoState: PhotoState?
    @Published var photosPickerItem: PhotosPickerItem? {
        didSet {
            if let photosPickerItem {
                Task {
                    photoState = .loading
                    photoState = await loadTransferable(from: photosPickerItem)
                }
            } else {
                photoState = nil
            }
        }
    }
    
    private func loadTransferable(from item: PhotosPickerItem) async -> PhotoState {
        guard let imageData = try? await item.loadTransferable(type: Data.self),
              let image = UIImage(data: imageData) else {
            return .failed
        }
        
        return .loaded(image)
    }
}
