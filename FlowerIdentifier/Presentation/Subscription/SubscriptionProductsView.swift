//
//  SubscriptionProductsView.swift
//  writeai
//
//  Created by Eilon Krauthammer on 17/06/2023.
//

import SwiftUI

struct SubscriptionProductsView: View {
    let products: [ProductDisplayItem]
    @Binding var selectedProduct: ProductDisplayItem?

    var body: some View {
        VStack(spacing: 12) {
            ForEach(products, id: \.self, content: productView)
        }
    }
    
    private func productView(_ product: ProductDisplayItem) -> some View {
        Button {
            selectedProduct = product
        } label: {
            HStack {
                Text(product.productTitle)
                    .font(.system(.callout, design: .rounded, weight: .medium))
                
                Spacer()
                
                Text(product.priceTitle)
                    .font(.callout)
                    .font(.system(.callout, design: .rounded))
            }
            .padding(12)
            .frame(height: 50)
            .background {
                Color.active
                    .opacity(0.045)
                    .cornerRadius(style: .large, strokeColor: .active.opacity(0.2), strokeWidth: 1)
            }
            .overlay {
                if selectedProduct == product {
                    RoundedRectangle(cornerRadius: CornerRadiusStyle.large.cornerRadius, style: .continuous)
                        .stroke(AccentGradient.gradient, lineWidth: 2.5)
                }
            }
            .overlay(alignment: .topTrailing) {
                if let badgeText = product.badge {
                    UIFactory.createBadge(text: badgeText, shadowColor: .clear)
                        .font(.system(.caption, design: .rounded, weight: .bold))
                        .offset(.init(width: -10, height: -10))
                }
            }
        }
        .springButtonStyle()
    }
}
