//
//  DetectionLoadingView.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 30/11/2023.
//

import SwiftUI

struct DetectionLoadingView: View {
    private let titles = ["Preparing Image", "Scanning Image", "Identifying Plant", "Searching Database", "Gathering Details"]
    @State private var currentTitleIndex = 0
    
    var body: some View {
        HStack(spacing: 12) {
            ProgressView()
            Text(titles[currentTitleIndex])
                .font(.system(.callout, design: .rounded, weight: .medium))
                .foregroundStyle(Color.subtitle)
                .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity),
                                        removal: .move(edge: .top).combined(with: .opacity)))
                .id(titles[currentTitleIndex])
        }
        .task(id: currentTitleIndex) {
            guard currentTitleIndex < titles.count - 1 else {
                return
            }
            
            try? await Task.sleep(for: .seconds(Double.random(in: 1.5...2.5)))
            withAnimation {
                currentTitleIndex += 1
            }
        }
    }
}
