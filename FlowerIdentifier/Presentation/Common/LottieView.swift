//
//  LottieView.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 30/11/2023.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let fileName: String
    let loopMode: LottieLoopMode
    var contentMode: UIView.ContentMode = .scaleAspectFill
    var speed: CGFloat = 1.0
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let animationView = LottieAnimationView(name: fileName)
        animationView.contentMode = contentMode
        animationView.loopMode = loopMode
        animationView.animationSpeed = speed
        animationView.play()
        animationView.clipsToBounds = true
        
        return animationView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}
