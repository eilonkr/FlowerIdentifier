//
//  SubscriptionInfoView.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 09/12/2023.
//

import SwiftUI

struct SubscriptionInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Text("Flower Identifier")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(.title)
                
                UIFactory.createBadge(text: "UNLIMITED", shadowColor: .black.opacity(0.2), isInverted: true)
                    .font(.system(.footnote, design: .rounded, weight: .heavy))
                    .kerning(1)
            }
            
            valueProposition("📸", "Scan and identify unlimited plants")
            valueProposition("✍️", "Detailed plant information, health report and care instructions")
            valueProposition("✨", "Full access to AI Chat")
            valueProposition("🔎", "Search and get details for any plant")
        }
    }
    
    private func valueProposition(_ emoji: String, _ text: String) -> some View {
        HStack(spacing: 16) {
            Text(emoji)
                .font(.headline)
            
            Text(text)
                .font(.system(.headline, design: .rounded, weight: .regular))
        }
    }
}
