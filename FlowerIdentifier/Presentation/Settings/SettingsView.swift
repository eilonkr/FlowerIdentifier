//
//  SettingsView.swift
//  Blurify-V2
//
//  Created by Eilon Krauthammer on 28/10/2022.
//

import SwiftUI
import StoreKit
import EmailComposer

struct SettingsView: View {
    @Environment(\.requestReview) private var requestReview
    @EnvironmentObject private var userState: UserState
    @State private var showsSubscription = false
    @State private var showsEmailComposer = false
    @State private var showsFeedbackSentAlert = false

    var body: some View {
        VStack(spacing: 0.0) {
            grabber

            List {
                Section {
                    coverGraphic
                    
                    if userState.isSubscribed == false {
                        SettingsListButton(title: "Upgrade to Unlimited", iconName: "crown.fill", action: upgradeToUnlimited)
                            .foregroundStyle(AccentGradient.gradient)
                    }
                }

                Group {
                    Section {
                        SettingsListButton(title: "Request a Feature", iconName: "square.and.pencil") {
                            showsEmailComposer = true
                        }
                    }
                    
                    Section {
//                        if let appstoreURLString = Constants.URLs.appstoreURL, let appstoreURL = URL(string: appstoreURLString) {
//                            SettingsListShareButton(title: "Share Write AI", shareURL: appstoreURL)
//                        }
                        
                        SettingsListButton(title: "Rate on the App Store", iconName: "star.fill") {
                            requestReview()
                        }

                        SettingsListButton(title: "Contact", iconName: "paperplane.fill") {
                            if let url = URL(string: Constants.URLs.contactURL),
                               UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            }
                        }
                    }

                    Section {
                        SettingsListButton(title: "Terms of Use") {
                            if let url = URL(string: Constants.URLs.termsOfServiceURLString),
                               UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            }
                        }

                        SettingsListButton(title: "Privacy Policy") {
                            if let url = URL(string: Constants.URLs.privacyPolicyURLString),
                               UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                }
                .foregroundColor(.title)
            }
            .font(.system(size: 16.0, weight: .medium))
        }
        .background(Color(.secondarySystemBackground))
        .alert("Feedback Sent", isPresented: $showsFeedbackSentAlert) {
            Button("OK", role: .cancel) {
                showsFeedbackSentAlert = false
            }
        } message: {
            Text("Your feedback was sent successfully. Thank you!")
        }
        .emailComposer(isPresented: $showsEmailComposer, emailData: Constants.Email.emailData, result: { result in
            if case .success = result {
                showsFeedbackSentAlert = true
            }
        })
    }

    private var coverGraphic: some View {
        SubscriptionAnimationView()
            .frame(height: 150.0)
            .listRowInsets(.init(.zero))
            .overlay(
                LinearGradient(colors: [.active.opacity(0.4), .active.opacity(0.0)],
                               startPoint: .top,
                               endPoint: .bottom)
            )
            .overlay {
                Text("Flower Identifier")
                    .font(.system(size: 24, weight: .bold, width: .expanded))
                    .foregroundStyle(Color.title.opacity(0.75))
            }
            .sheet(isPresented: $showsSubscription, content: SubscriptionView.init)
    }

    private var grabber: some View {
        Capsule()
            .foregroundColor(Color(.systemGray3))
            .frame(width: 30.0, height: 4.0)
            .padding(10.0)
    }

    private func upgradeToUnlimited() {
        showsSubscription = true
    }
}

