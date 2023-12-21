//
//  CreditsButton.swift
//  FlowerIdentifier
//
//  Created by Eilon Krauthammer on 22/12/2023.
//

import SwiftUI

struct CreditsButton: View {
    let action: () -> Void
    @EnvironmentObject private var userState: UserState
    
    private var buttonText: String {
        return if userState.isSubscribed {
            "∞"
        } else {
            "\(FeatureFlags.freeIdentifications - userState.numberOfIdentifications)"
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: "sparkles")
                    .font(.system(.caption, design: .rounded, weight: .semibold))
                
                Text(buttonText)
            }
            .foregroundStyle(.title)
            .font(.system(.body, design: .rounded, weight: .semibold))
            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            .background(AccentGradient())
            .clipShape(Capsule(style: .continuous))
        }
        .springButtonStyle()
    }
}
