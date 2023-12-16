//
//  SubscriptionLegalButtons.swift
//  writeai
//
//  Created by Eilon Krauthamer on 08/07/2023.
//

import SwiftUI
import EKAppFramework

struct SubscriptionLegalButtons: View {
    @EnvironmentObject private var adaptyManager: AdaptyManager
    
    let restoreHandler: () -> Void
    
    var body: some View {
        HStack(spacing: 24.0) {
            Button("Privacy Policy") {
                if let url = URL(string: Constants.URLs.privacyPolicyURLString),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            
            Button("Terms of Use") {
                if let url = URL(string: Constants.URLs.termsOfServiceURLString),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            
            Button("Restore Purchases") {
                restoreHandler()
            }
        }
        .foregroundColor(.secondary)
        .font(.system(.caption, design: .rounded, weight: .regular))
    }
}
