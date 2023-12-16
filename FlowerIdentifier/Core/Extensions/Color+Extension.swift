//
//  Color+Extension.swift
//  writeai
//
//  Created by Eilon Krauthammer on 27/05/2023.
//

import SwiftUI

extension Color {
    static let active = Color(UIColor(hex: "A1CD00"))
    static let subtitle = Color(.secondaryLabel)
    static let separator = title.opacity(0.09)
    
    static func createGradientOverlay() -> some View {
        RadialGradient(colors: [.active.opacity(0.4), .active.opacity(0)], center: .top, startRadius: 0, endRadius: 300)
    }
}

struct AccentGradient: View {
    static var gradient: Gradient {
        Gradient(colors: [.active, Color(uiColor: .init(hex: "ffa200"))])
    }
    
    var body: some View {
        LinearGradient(gradient: AccentGradient.gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

