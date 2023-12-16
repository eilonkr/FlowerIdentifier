//
//  OnboardingReportsView.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 08/12/2023.
//

import SwiftUI

struct OnboardingReportsView: View {
    let onFinish: () -> Void
    
    var body: some View {
        VStack(spacing: 34) {
            ReportView()
                .frame(maxWidth: 500, maxHeight: 500)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 16) {
                Text("Detailed Plant Info")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .kerning(0.3)
                    .foregroundStyle(Color.title.opacity(0.85))
                
                Text("Get in-depth plant information, health reports and care instructions.")
                    .font(.system(.body, design: .rounded, weight: .medium))
            }
            
            PrimaryCTAButton(action: onFinish)
                .frame(height: 80, alignment: .top)
                .frame(maxWidth: 500)
        }
        .multilineTextAlignment(.center)
    }
}

private struct ReportView: View {
    @State private var sectionIndex = 0
    private let totalSections = 3
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 20) {
                if sectionIndex >= 0 {
                    HStack(spacing: 12) {
                        Image("sunflower")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 57, height: 60)
                            .cornerRadius(style: .small)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Sunflower")
                                .font(.system(.body, design: .rounded, weight: .semibold))
                            Text("Helianthus annus")
                                .font(.system(.callout, design: .serif, weight: .semibold))
                        }
                        
                        Spacer()
                        
                        Image(systemName: "doc.on.doc.fill")
                            .foregroundStyle(Color.subtitle)
                            .font(.system(.callout, weight: .bold))
                            .frame(height: 22)
                    }
                }
                
                if sectionIndex > 0 {
                    Text("Sunflowers are tall, annual plants with large, yellow flowers native to North America. They track the sun, have broad leaves, and yield edible seeds. Symbolizing positivity, they're cultivated for beauty and practical uses like oil extraction.")
                        .font(.system(.callout, design: .rounded, weight: .regular))
                        .lineSpacing(4)
                        .multilineTextAlignment(.leading)
                        .transition(.offset(y: -20).combined(with: .fade))
                }
                
                if sectionIndex > 1 {
                    PlantInfoSectionView(title: "HEALTH", systemImageName: "heart.fill", ignorePadding: true) {
                        PlantHealthBox(plantName: "Sunflower", health: .init(status: .ok, problems: []))
                            .frame(maxWidth: .infinity)
                            .disabled(true)
                    }
                    .transition(.offset(y: -20).combined(with: .fade))
                }
                
                if sectionIndex > 2 {
                    instructionsSection()
                        .transition(.offset(y: -20).combined(with: .fade))
                }
            }
            .padding(16)
        }
        .disabled(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.tertiarySystemBackground))
        .mask(
            LinearGradient(stops: [.init(color: .black, location: 0.8),
                                   .init(color: .black.opacity(0), location: 1.0)],
                           startPoint: .top,
                           endPoint: .bottom)
        )
        .cornerRadius(style: .large)
        .shadow(color: .black.opacity(0.1), radius: 16, y: 4)
        .padding(.top, 20)
        .task(id: sectionIndex) {
            if sectionIndex < totalSections {
                try? await Task.sleep(for: .seconds(0.7))
                withAnimation(.smooth(duration: 0.4)) {
                    sectionIndex += 1
                }
            }
        }
    }
    
    @ViewBuilder private func instructionsSection() -> some View {
        let instructionsText = """
        1. Sunlight: Place the Sunflower in a location with full sunlight for at least 6-8 hours a day.
        2. Watering: Ensure the soil remains consistently moist but not waterlogged. Water the Sunflower thoroughly when the top inch of the soil feels dry to the touch. Use well-draining soil to prevent root rot.
        3. Fertilization: Feed the Sunflower with a balanced liquid fertilizer every 2-4 weeks during the growing season (spring and summer). Dilute the fertilizer according to the package instructions to avoid over-fertilizing, which can harm the plant.
        """
        
        PlantInfoSectionView(title: "CARE INSTRUCTIONS", systemImageName: "checklist", ignorePadding: true) {
            Text(instructionsText)
                .font(.system(.callout, design: .rounded, weight: .regular))
                .multilineTextAlignment(.leading)
                .minimumScaleFactor(0.5)
        }
    }
}
