//
//  OnboardingSubscriptionModel.swift
//  writeai
//
//  Created by Eilon Krauthammer on 03/06/2023.
//

import Foundation
import Adapty

class SubscriptionModel: ObservableObject {
    enum Product: String, Hashable {
        case unlimitedWeekly = "PlantIdentifierAI.Weekly.3USD"
        case unlimitedMonthly = "PlantIdentifierAI.Monthly.6USD"
        case unlimitedAnnual = "PlantIdentifierAI.Annual.40USD"
        case unlimitedAnnualFreeTrial = "PlantIdentifierAI.Annual.40USD.3Days.FreeTrial"
        
        var title: String {
            return switch self {
            case .unlimitedWeekly:
                "Unlimited Weekly"
            case .unlimitedMonthly:
                "Unlimited Monthly"
            case .unlimitedAnnual, .unlimitedAnnualFreeTrial:
                "Unlimted Annual"
            }
        }
        
        func badgeTitle(hasFreeTrial: Bool) -> String? {
            return switch self {
            case .unlimitedMonthly, .unlimitedWeekly:
                nil
            case .unlimitedAnnual:
                "BEST VALUE"
            case .unlimitedAnnualFreeTrial:
                hasFreeTrial ? "FREE TRIAL" : "BEST VALUE"
            }
        }
    }
    
    var products = [AdaptyPaywallProduct]() {
        didSet {
            parseProductsToOfferings()
            selectedProductDisplayItem = productDisplayItems.first
            onboardingProduct = createOnboardingProduct()
        }
    }
    
    var onboardingProduct: AdaptyPaywallProduct?
    var selectedProduct: AdaptyPaywallProduct? {
        return products.first { $0.vendorProductId == selectedProductDisplayItem?.productId }
    }
    
    @Published var productDisplayItems = [ProductDisplayItem]()
    @Published var selectedProductDisplayItem: ProductDisplayItem?
    
    // MARK: - Public
    func purchaseTitle(for productModel: AdaptyPaywallProduct) -> String? {
        return if productModel.hasFreeTrial, let introString = productModel.introString {
            "Unlock unlimited access for just \(productModel.productDescription) with \(introString)"
        } else {
            "Unlock unlimited access to Flower Identifier for just \(productModel.productDescription)"
        }
    }
    
    // MARK: - Private
    private func parseProductsToOfferings() {
        let sortedProducts = products.sorted { $0.price > $1.price }
        let filterMonthlyOrWeeklyProduct = [Product.unlimitedWeekly, Product.unlimitedMonthly].randomElement()!
        productDisplayItems = sortedProducts
            .compactMap { parseProductModelToDisplayItem($0) }
            .filter {
                if FeatureFlags.isFreeTrialAllowed == false && $0.hasFreeTrial {
                    return false
                } else if FeatureFlags.isFreeTrialAllowed && $0.productId == Product.unlimitedAnnual.rawValue {
                    return false
                }
                
                return true
            }
            .filter { $0.productId != filterMonthlyOrWeeklyProduct.rawValue }
    }
    
    private func parseProductModelToDisplayItem(_ productModel: AdaptyPaywallProduct) -> ProductDisplayItem? {
        guard let product = Product(rawValue: productModel.vendorProductId) else {
            return nil
        }
        
        return ProductDisplayItem(productId: productModel.vendorProductId,
                                  price: productModel.price,
                                  productTitle: product.title,
                                  priceTitle: productModel.productDescription,
                                  hasFreeTrial: productModel.hasFreeTrial,
                                  badge: product.badgeTitle(hasFreeTrial: productModel.hasFreeTrial))
    }
    
    private func createOnboardingProduct() -> AdaptyPaywallProduct? {
        let availableProducts = products
            .filter {
                if FeatureFlags.isFreeTrialAllowed == false && $0.hasFreeTrial {
                    return false
                } else if FeatureFlags.isFreeTrialAllowed && $0.vendorProductId == Product.unlimitedAnnual.rawValue {
                    return false
                }
                
                return true
            }
        
        return availableProducts.randomElement()
    }
}
