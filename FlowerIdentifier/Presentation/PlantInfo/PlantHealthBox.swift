//
//  HealthStatusButton.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthamer on 03/12/2023.
//

import SwiftUI

struct PlantHealthBox: View {
    let plantName: String
    let health: PlantHealth
    @State private var showsProblems = false
    
    var body: some View {
        VStack(spacing: 12) {
            Button {
                withAnimation {
                    showsProblems.toggle()
                }
            } label: {
                HStack {
                    healthBadge()
                    
                    Spacer()
                    
                    if health.problems != nil {
                        HStack(spacing: 6) {
                            Text(showsProblems ? "See less" : "Learn more")
                            Image(systemName: "chevron.right")
                                .rotationEffect(.degrees(showsProblems ? -90 : 0))
                        }
                        .foregroundStyle(Color.subtitle)
                        .font(.system(.callout, design: .rounded, weight: .semibold))
                    }
                }
                .padding(12)
                .background(Color(.quaternarySystemFill))
                .cornerRadius(style: .small)
            }
            .springButtonStyle()
            
            if showsProblems, let problems = health.problems {
                CareInstructionsBox(mode: .problems, plantName: plantName, instructions: problems)
            }
        }
    }
    
    private func healthBadge() -> some View {
        Text(health.status.title)
            .foregroundStyle(health.status.textColor)
            .font(.system(.callout, design: .rounded, weight: .bold))
            .padding(.vertical, 4)
            .padding(.horizontal, 10)
            .background(
                health.status.color
                    .clipShape(Capsule(style: .continuous))
            )
    }
}
