//
//  AdaptyProductModel+Extensions.swift
//  writeai
//
//  Created by Eilon Krauthammer on 09/07/2023.
//

import Adapty

extension AdaptyPaywallProduct {
    var productDescription: String {
        if subscriptionPeriod == nil {
            return localizedPrice ?? ""
        }
        
        guard let subscriptionPeriod else {
            return ""
        }
        
        var duration = subscriptionPeriod.unit
        if subscriptionPeriod.numberOfUnits == 7 {
            duration = .week
        }
        
        return "\(localizedPrice ?? String(describing: price))/\(duration)"
    }
    
    var introString: String? {
        if let introductoryDiscount {
            return "\(introductoryDiscount.localizedSubscriptionPeriod ?? "") FREE"
        }
        
        return nil
    }
    
    var hasFreeTrial: Bool {
        get async throws {
            let adaptyEligibility = try await Adapty.getProductsIntroductoryOfferEligibility(vendorProductIds: [vendorProductId])
            let eligibility = adaptyEligibility[vendorProductId]
            
            return eligibility == .eligible && introductoryDiscount?.paymentMode == .freeTrial
        }
    }
    
    var isSubscription: Bool {
        return subscriptionPeriod != nil
    }
}
