//
//  PlantInfoBox.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthamer on 03/12/2023.
//

import SwiftUI

struct PlantInfoBox: View {
    let title: String
    let systemImageName: String
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: systemImageName)
                Text(title)
            }
            .font(.system(.footnote, design: .rounded, weight: .semibold))
            .foregroundStyle(Color.subtitle)
            
            Text(text)
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(Color.title)
                .minimumScaleFactor(0.5)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(height: 82)
        .background(Color(.quaternarySystemFill))
        .cornerRadius(style: .small)
    }
}
