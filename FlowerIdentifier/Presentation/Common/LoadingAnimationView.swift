//
//  LoadingAnimationView.swift
//  writeai
//
//  Created by Eilon Krauthammer on 27/05/2023.
//

import SwiftUI

struct LoadingAnimationView: View {
    var spacing: CGFloat = 10
    private let animationDuration: Double = 0.4
    private let animationDelayIncrement: Double = 0.2
    private let maximumScale: Double = 1.3
    
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0 ..< 3) { index in
                Circle()
                    .opacity(opacity(for: scale))
                    .scaleEffect(scale)
                    .animation(Animation.easeOut(duration: animationDuration)
                        .repeatForever().delay(animationDelay(for: index)), value: UUID())
                    .onAppear {
                        DispatchQueue.main.async {
                            self.scale = maximumScale
                        }
                    }
            }
        }
        .frame(height: 8)
    }
    
    private func animationDelay(for index: Int) -> Double {
        return Double(index) * animationDelayIncrement
    }
    
    private func opacity(for scale: CGFloat) -> Double {
        let minimumScale: CGFloat = 1.0
        let maximumScale: CGFloat = maximumScale
        let minimumOpacity: Double = 0.5
        let maximumOpacity: Double = 1.0
        
        let normalizedScale = (scale - minimumScale) / (maximumScale - minimumScale)
        return minimumOpacity + Double(normalizedScale) * (maximumOpacity - minimumOpacity)
    }
}

struct LoadingAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingAnimationView()
            .foregroundColor(.blue)
    }
}
