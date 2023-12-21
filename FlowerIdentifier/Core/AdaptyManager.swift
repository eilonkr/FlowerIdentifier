//
//  AdaptyManager.swift
//  Word Story
//
//  Created by Eilon Krauthammer on 23/04/2021.
//

import Foundation
import Adapty
import EKAppFramework

@MainActor class AdaptyManager: ObservableObject {
    typealias ProductsResultHandler = (Result<[AdaptyPaywallProduct], AdaptyError>) -> Void
    typealias PurchaseResultHandler = (PurchaseResult) -> Void
    
    public var userState: UserStateProtocol!
    @Published var products = [AdaptyPaywallProduct]()
    
    func purchase(_ product: AdaptyPaywallProduct, result: @escaping PurchaseResultHandler) {
        Adapty.makePurchase(product: product) { [weak self] adaptyResult in
            switch adaptyResult {
            case .success(let profile):
                let isSubscribed = profile.accessLevels["premium"]?.isActive ?? false
                self?.userState.isSubscribed = isSubscribed
                result(.success)
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
    func restore(_ result: @escaping PurchaseResultHandler) {
        Adapty.restorePurchases { [weak self] adaptyResult in
            switch adaptyResult {
            case .success(let profile):
                let isSubscribed = profile.accessLevels["premium"]?.isActive ?? false
                self?.userState.isSubscribed = isSubscribed
                if isSubscribed {
                    result(.success)
                } else {
                    let error = NSError(domain: "Restored subscription not availble.", code: 0, userInfo: [:])
                    result(.failure(error))
                }
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
    func prefetchProducts(completion: (() -> Void)? = nil) {
        fetchProducts(paywallId: "FlowerIdentifier.General") { _ in
            completion?()
        }
    }
    
    private func fetchProducts(paywallId: String, filteredTo productIDs: Set<String>? = nil, result: ProductsResultHandler?) {
        fetchProducts(for: paywallId) { [weak self] productsResult in
            switch productsResult {
            case .success(let products):
                let filteredProducts = products.filter {
                    productIDs?.contains($0.vendorProductId) ?? true
                }
    
                self?.products = products
                result?(.success(filteredProducts))
            case .failure(let error):
                result?(.failure(error))
            }
        }
    }
    
    private func fetchProducts(for paywallId: String, result: @escaping ProductsResultHandler) {
        Adapty.getPaywall(paywallId) { adaptyResult in
            switch adaptyResult {
            case .success(let paywall):
                Adapty.getPaywallProducts(paywall: paywall) { paywallProductsResult in
                    switch paywallProductsResult {
                    case .success(let products):
                        result(.success(products))
                    case .failure(let error):
                        result(.failure(error))
                    }
                }
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
}
