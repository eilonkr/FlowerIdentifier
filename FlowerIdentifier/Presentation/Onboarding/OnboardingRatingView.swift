//
//  OnboardingRatingView.swift
//  FlowerIdentifier
//
//  Created by Eilon Krauthammer on 22/12/2023.
//

import SwiftUI

struct OnboardingRatingView: View {
    let onFinish: () -> Void
    @Environment(\.requestReview) private var requestReview
    @State private var didRequestReview = false
    
    var body: some View {
        VStack(spacing: 34) {
            Spacer()
            
            Text("Please rate us to\nsupport our work ❤️")
                .font(.system(.title3, design: .rounded, weight: .medium))
                .multilineTextAlignment(.center)
            
            LottieView(fileName: "rating-stars", loopMode: .loop, contentMode: .scaleAspectFit)
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 20)
                .scaleEffect(0.25)
            
            Spacer()
            
            PrimaryCTAButton {
                if didRequestReview == false {
                    didRequestReview = true
                    requestReview()
                } else {
                    onFinish()
                }
            }
            .frame(height: 80, alignment: .top)
            .frame(maxWidth: 500)
        }
    }
}
