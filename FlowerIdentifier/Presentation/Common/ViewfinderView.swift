//
//  ViewfinderView.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 08/12/2023.
//

import SwiftUI

struct ViewfinderView: View {
    var insets: UIEdgeInsets = .even(40)
    
    var body: some View {
        ViewfinderShape(insets: insets,
                        lineLength: 40,
                        cornerRadius: 12)
            .stroke(.white, style: StrokeStyle(lineWidth: 4, lineCap: .round))
            .shadow(color: .black.opacity(0.25), radius: 8)
    }
}
