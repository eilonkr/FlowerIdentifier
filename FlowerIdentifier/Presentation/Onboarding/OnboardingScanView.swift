//
//  OnboardingScanView.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 08/12/2023.
//

import SwiftUI

struct OnboardingScanView: View {
    let onFinish: () -> Void
    
    var body: some View {
        VStack(spacing: 34) {
            ScanDemoView()
                .padding(.vertical)
                .frame(maxWidth: 500)
            
            VStack(spacing: 16) {
                Text("Scan Any Plant")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .kerning(0.3)
                    .foregroundStyle(Color.title.opacity(0.85))
                
                Text("Identify any plant in seconds,\nusing the power of AI.")
                    .font(.system(.body, design: .rounded, weight: .medium))
            }
            
            PrimaryCTAButton(action: onFinish)
                .frame(height: 80, alignment: .top)
                .frame(maxWidth: 500)
        }
        .multilineTextAlignment(.center)
    }
}
