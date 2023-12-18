//
//  OnboardingSubscriptionView.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 09/12/2023.
//

import SwiftUI

struct OnboardingSubscriptionView: View {
    @ObservedObject var subscriptionModel: SubscriptionModel
    @Binding var onboardingResult: OnboardingResult?
    @Binding var isLoading: Bool
    @EnvironmentObject private var adaptyManager: AdaptyManager
    
    private var subscriptionText: String {
        if let onboardingProduct = subscriptionModel.onboardingProduct,
           let purchaseTitle = subscriptionModel.purchaseTitle(for: onboardingProduct) {
            return purchaseTitle
        } else {
            return "Get started with Flower Identifier now!"
        }
    }
    
    var body: some View {
        VStack(spacing: 34) {
            Spacer()
            
            SubscriptionInfoView()
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .padding(.vertical, 16)
            
            Text(subscriptionText)
                .font(.system(.callout, design: .rounded, weight: .regular))
            
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    PrimaryCTAButton {
                        isLoading = true
                        if let onboardingProduct = subscriptionModel.onboardingProduct {
                            adaptyManager.purchase(onboardingProduct) { purchaseResult in
                                isLoading = false
                                switch purchaseResult {
                                case .success:
                                    AnalyticsService.logEvent(name: "purchase_onboarding",
                                                              value: onboardingProduct.vendorProductId)
                                    onboardingResult = .purchase
                                case .failure:
                                    onboardingResult = .error
                                }
                            }
                        } else {
                            onboardingResult = .dismiss
                        }
                    }
                    .frame(maxWidth: 500)
                    
                    Text("No commitment. Cancel anytime.")
                        .font(.caption)
                        .foregroundColor(Color.secondary)
                }
                
                SubscriptionLegalButtons(restoreHandler: {
                    withAnimation { isLoading = true }
                    adaptyManager.restore { result in
                        withAnimation { isLoading = false }
                        switch result {
                        case .success:
                            onboardingResult = .restore
                        case .failure:
                            onboardingResult = .error
                        }
                    }
                })
            }
            .frame(height: 80, alignment: .top)
        }
        .multilineTextAlignment(.center)
    }
}
