//
//  ScanDemoView.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 09/12/2023.
//

import SwiftUI

struct ScanDemoView: View {
    var imageAspectRatio: CGFloat? = 5/7
    var viewfinderInsets: UIEdgeInsets = .even(30)
    
    @State private var imageIndex = 0
    private let demoImageNames = ["demo-1", "demo-2", "demo-3", "sunflower"]
    private var nextImageIndex: Int {
        if demoImageNames.indices.contains(imageIndex + 1) {
            return imageIndex + 1
        }
        
        return 0
    }
    
    var body: some View {
        GeometryReader { proxy in
            Image(demoImageNames[imageIndex])
                .resizable()
                .aspectRatio(contentMode: .fill)
                .scaledToFill(aspectRatio: imageAspectRatio)
                .cornerRadius(style: .large)
                .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                                        removal: .move(edge: .leading).combined(with: .opacity)))
                .frame(width: proxy.size.width, height: proxy.size.height)
                .id(imageIndex)
        }
        .overlay {
            ViewfinderView(insets: viewfinderInsets)
                .aspectRatio(imageAspectRatio, contentMode: .fit)
        }
        .task(id: imageIndex) {
            try? await Task.sleep(for: .seconds(1.35))
            withAnimation(.smooth(duration: 0.3)) {
                imageIndex = nextImageIndex
            }
        }
    }
}
