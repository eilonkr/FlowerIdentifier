//
//  PlantInfoSectionView.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthamer on 03/12/2023.
//

import SwiftUI

struct PlantInfoSectionView<Content: View>: View {
    let title: String
    let systemImageName: String
    var ignorePadding = false
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: systemImageName)
                Text(title)
            }
            .font(.system(.footnote, design: .rounded, weight: .semibold))
            .foregroundStyle(Color.subtitle)
            
            content()
        }
        .modify { view in
            if !ignorePadding {
                view.padding(.horizontal)
            } else {
                view
            }
        }
    }
}
