//
//  PrimaryCTAButton.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 08/12/2023.
//

import SwiftUI

struct PrimaryCTAButton: View {
    let action: () -> Void
    private let title: String
    
    @Environment(\.isEnabled) private var isEnabled
    
    init(title: String = "CONTINUE", action: @escaping () -> Void) {
        self.action = action
        self.title = title
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .kerning(0.3)
                .foregroundStyle(.title)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AccentGradient.gradient)
                .cornerRadius(style: .custom(16))
                .shadow(color: .title.opacity(0.3), radius: 8, y: 4)
                .opacity(isEnabled ? 1 : 0.42)
        }
        .springButtonStyle()
    }
}
