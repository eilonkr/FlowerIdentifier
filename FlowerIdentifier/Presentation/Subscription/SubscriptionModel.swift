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
        case unlimitedWeekly = "FlowerIdentifier.Weekly.3USD"
        case unlimitedAnnualFreeTrial = "FlowerIdentifier.Yearly.35USD.3Day.FreeTrial"
        
        var title: String {
            return switch self {
            case .unlimitedWeekly:
                "Unlimited Weekly"
            case .unlimitedAnnualFreeTrial:
                "Unlimted Annual"
            }
        }
        
        func badgeTitle(hasFreeTrial: Bool) -> String? {
            return switch self {
            case .unlimitedWeekly:
                nil
            case .unlimitedAnnualFreeTrial:
                hasFreeTrial ? "FREE TRIAL" : "BEST VALUE"
            }
        }
    }
    
    var products = [AdaptyPaywallProduct]() {
        didSet {
            Task(priority: .userInitiated) {
                await parseProductsToOfferings()
                selectedProductDisplayItem = productDisplayItems.first
                onboardingProduct = createOnboardingProduct()
            }
        }
    }
    
    var onboardingProduct: AdaptyPaywallProduct?
    var selectedProduct: AdaptyPaywallProduct? {
        return products.first { $0.vendorProductId == selectedProductDisplayItem?.productId }
    }
    
    @Published var productDisplayItems = [ProductDisplayItem]()
    @Published var selectedProductDisplayItem: ProductDisplayItem?
    
    // MARK: - Public
    func purchaseTitle(for productModel: AdaptyPaywallProduct) async -> String? {
        return if (try? await productModel.hasFreeTrial) == true, let introString = productModel.introString {
            "Unlock unlimited access for just \(productModel.productDescription) with \(introString)"
        } else {
            "Unlock unlimited access to Flower Identifier for just \(productModel.productDescription)"
        }
    }
    
    // MARK: - Private
    private func parseProductsToOfferings() async {
        let sortedProducts = products.sorted { $0.price > $1.price }
        var productDisplayItems = [ProductDisplayItem]()
        for product in sortedProducts {
            if let displayItem = await parseProductModelToDisplayItem(product) {
                productDisplayItems.append(displayItem)
            }
        }
    }
    
    private func parseProductModelToDisplayItem(_ productModel: AdaptyPaywallProduct) async -> ProductDisplayItem? {
        guard let product = Product(rawValue: productModel.vendorProductId) else {
            return nil
        }
        
        let hasFreeTrial = (try? await productModel.hasFreeTrial) == true
        return ProductDisplayItem(productId: productModel.vendorProductId,
                                  price: productModel.price,
                                  productTitle: product.title,
                                  priceTitle: productModel.productDescription,
                                  hasFreeTrial: hasFreeTrial,
                                  badge: product.badgeTitle(hasFreeTrial: hasFreeTrial))
    }
    
    private func createOnboardingProduct() -> AdaptyPaywallProduct? {
        let availableProducts = products
        
        return availableProducts.randomElement()
    }
}
