//
//  SubscriptionView.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 06/12/2023.
//

import SwiftUI

struct SubscriptionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var adaptyManager: AdaptyManager
    @StateObject private var subscriptionModel = SubscriptionModel()
    @State private var isLoading = false
    @State private var purchaseTitle = ""
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            SubscriptionInfoView()
                        
            VStack(spacing: 24) {
                SubscriptionProductsView(products: subscriptionModel.productDisplayItems,
                                         selectedProduct: $subscriptionModel.selectedProductDisplayItem)
                
                Text(purchaseTitle)
                    .font(.system(.callout, design: .rounded, weight: .regular))
                    .multilineTextAlignment(.center)
                    .frame(height: 44)
                    .task {
                        if let selectedProduct = subscriptionModel.selectedProduct {
                            purchaseTitle = await subscriptionModel.purchaseTitle(for: selectedProduct) ?? ""
                        }
                    }
                
                VStack(spacing: 16) {
                    subscribeButton()
                    
                    SubscriptionLegalButtons(restoreHandler: {
                        isLoading = true
                        adaptyManager.restore { result in
                            isLoading = false
                            if case .success = result {
                                dismiss()
                            }
                        }
                    })
                }
                .padding(.horizontal, 8)
            }
        }
        .padding(EdgeInsets(top: 0, leading: 24, bottom: 20, trailing: 24))
        .frame(maxHeight: .infinity)
        .background(alignment: .top) {
            SubscriptionAnimationView()
        }
        .background(alignment: .top) {
            Color.background
                .ignoresSafeArea()
                .overlay {
                    Color.createGradientOverlay()
                        .offset(y: -140)
                }
        }
        .overlay(alignment: .topTrailing) {
            UIFactory.createCloseButton(action: dismiss.callAsFunction)
                .foregroundStyle(Color.white)
                .shadow(color: .black.opacity(0.2), radius: 4)
                .padding([.trailing, .top], 24)
        }
        .viewLoading(isLoading)
        .onReceive(adaptyManager.$products) { products in
            subscriptionModel.products = products
        }
    }
    
    private func subscribeButton() -> some View {
        PrimaryCTAButton {
            isLoading = true
            if let selectedProduct = subscriptionModel.selectedProduct {
                adaptyManager.purchase(selectedProduct) { result in
                    isLoading = false
                    if case .success = result {
                        dismiss()
                    }
                }
            }
        }
    }
}
