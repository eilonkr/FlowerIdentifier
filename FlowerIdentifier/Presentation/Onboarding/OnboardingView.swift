//
//  OnboardingView.swift
//  writeai
//
//  Created by Eilon Krauthammer on 02/06/2023.
//

import SwiftUI
import EKAppFramework
import EKSwiftSuite

enum OnboardingPage: String, Equatable {
    case scan
    case enableCameraAccess
    case reports
    case aiChat
    case ratings
    case subscription
}

enum OnboardingResult {
    case purchase
    case dismiss
    case restore
    case error
}

struct OnboardingView: View {
    @EnvironmentObject private var userState: UserState
    @EnvironmentObject private var adaptyManager: AdaptyManager
    @StateObject private var subscriptionModel = SubscriptionModel()
    @State private var page: OnboardingPage = .scan
    @State private var onboardingResult: OnboardingResult?
    @State private var isLoading: Bool = false
    @State private var showsCloseButton = false
    
    var body: some View {
        viewForCurrentPage()
            .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)))
            .id(page)
            .padding(.top, 60)
            .padding(.bottom, 30)
            .padding(.horizontal, 32)
            .background(alignment: .top) {
                if page == .subscription {
                    ScanDemoView(imageAspectRatio: nil, viewfinderInsets: .even(42))
                        .mask {
                            LinearGradient(stops: [.init(color: .black, location: 0),
                                                   .init(color: .black.opacity(0), location: 1)],
                                           startPoint: .top,
                                           endPoint: .bottom)
                        }
//                     Additional mask
//                        .mask {
//                            LinearGradient(stops: [.init(color: .black, location: 0.4),
//                                                   .init(color: .black.opacity(0), location: 1)],
//                                           startPoint: .bottom,
//                                           endPoint: .top)
//                        }
                        .frame(height: UIScreen.main.bounds.height * 0.45)
                        .ignoresSafeArea()
                }
            }
            .background(alignment: .top) {
                Color.background
                    .ignoresSafeArea()
                    .overlay {
                        Color.createGradientOverlay()
                            .offset(y: -80)
                            .opacity(0.65)
                            .ignoresSafeArea()
                    }
                    .overlay(alignment: .top) {
                        if page != .subscription {
                            SubscriptionAnimationView(numberOfRows: 1, emojiSize: 40)
                                .opacity(0.4)
                                .padding(.top, 8)
                        }
                    }
            }
            .overlay(alignment: .topTrailing) {
                if showsCloseButton {
                    UIFactory.createCloseButton {
                        onboardingResult = .dismiss
                    }
                    .foregroundStyle(.white)
                    .padding(16)
                }
            }
            .viewLoading(isLoading)
            .animation(.linear(duration: 0.2), value: isLoading)
            .statusBarHidden()
            .onChange(of: page) { page in
                AnalyticsService.logEvent(name: "page_\(page.rawValue)")
                
                if page == .subscription {
                    Task {
                        try await Task.sleep(for: .seconds(FeatureFlags.onboardingCloseButtonShowDuration))
                        withAnimation(.linear(duration: 0.7)) {
                            showsCloseButton = true
                        }
                    }
                }
            }
            .onChange(of: onboardingResult) { result in
                withAnimation(.easeInOut(duration: 0.5)) {
                    if result != .error {
                        userState.didSeeOnboarding = true
                    }
                }
            }
            .onReceive(adaptyManager.$products) { products in
                subscriptionModel.products = products
            }
    }
    
    @ViewBuilder private func viewForCurrentPage() -> some View {
        switch page {
        case .scan:
            OnboardingScanView { setPage(.reports) }
        case .reports:
            OnboardingReportsView { setPage(.aiChat) }
        case .aiChat:
            OnboardingChatView { setPage(.ratings) }
        case .ratings:
            OnboardingRatingView { setPage(.enableCameraAccess) }
        case .enableCameraAccess:
            OnboardingCameraAccessView { setPage(.subscription) }
        case .subscription:
            OnboardingSubscriptionView(subscriptionModel: subscriptionModel,
                                       onboardingResult: $onboardingResult,
                                       isLoading: $isLoading)
        }
    }
    
    
    // MARK: - Private
    private func setPage(_ page: OnboardingPage) {
        Haptic.selection.generate()
        withAnimation(.smooth(duration: 0.4)) {
            self.page = page
        }
    }
}

// MARK: - Preview
#Preview {
    OnboardingView()
}
