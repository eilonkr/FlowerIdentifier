//
//  RootView.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 29/11/2023.
//

import SwiftUI
import TipKit
import EKAppFramework
import Adapty

enum MainNavigationPath: Hashable {
    case plantInfoView(IdentificationResponse)
    case recentItemPlantInfo(RecentItem)
    case chat(IdentificationResponse)
}

struct RootView: View {
    @EnvironmentObject private var userState: UserState
    @StateObject private var adaptyManager = AdaptyManager()
    @StateObject private var appModel = AppModel()
    @StateObject private var recentItemsStorage = LocalStorage<RecentItem>()
    
    var body: some View {
        Group {
            if userState.didSeeOnboarding {
                mainTabView()
                    .transition(.push(from: .trailing).combined(with: .opacity))
            } else {
                OnboardingView()
            }
        }
        .environmentObject(appModel)
        .environmentObject(recentItemsStorage)
        .sheet(isPresented: $appModel.showsSettings, content: SettingsView.init)
        .sheet(isPresented: $appModel.showsDebugMenu, content: DebugMenuView.init)
        .fullScreenCover(isPresented: $appModel.showsSubscription, content: SubscriptionView.init)
        .environmentObject(adaptyManager)
        .onLoad {
            setupNavigationBarAppearance()
            configureAdapty()
            setupTipsIfNeeded()
        }
    }
    
    private func mainTabView() -> some View {
        TabView {
            ScannerView()
                .tabItem {
                    Image(systemName: "viewfinder")
                    Text("Scanner")
                }
                .toolbarBackground(.visible, for: .tabBar)
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .toolbarBackground(.visible, for: .tabBar)
            
            RecentsView()
                .tabItem {
                    Image(systemName: "camera.macro")
                    Text("My Garden")
                }
                .toolbarBackground(.visible, for: .tabBar)
        }
    }
    
    // MARK: - Private
    private func setupTipsIfNeeded() {
        if #available(iOS 17, *) {
            if userState.resetTipsOnNextLaunch {
                try? Tips.resetDatastore()
            }
            
            try? Tips.configure([
                .datastoreLocation(.applicationDefault),
                .displayFrequency(.immediate)
            ])
        }
    }
    
    private func configureAdapty() {
        Adapty.activate("public_live_UyS3bTME.yeo2ZKxPTRCaREWbdpBc")
        Adapty.logLevel = .error
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            Adapty.getProfile { result in
                switch result {
                case .success(let profile):
                    let isSubscribed = profile.accessLevels["premium"]?.isActive ?? false
                    userState.isSubscribed = isSubscribed
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        adaptyManager.userState = userState
        adaptyManager.prefetchProducts()
    }
    
    private func setupNavigationBarAppearance() {
        let largeTitleTextAttributes: [NSMutableAttributedString.Key: Any] = [.foregroundColor: UIColor.title,
                                                                              .font: UIFont.roundedFont(size: 32, weight: .bold)]
        let regularTitleTextAttributes: [NSMutableAttributedString.Key: Any] = [.foregroundColor: UIColor.title,
                                                                                .font: UIFont.roundedFont(size: 16, weight: .semibold)]
        UINavigationBar.appearance().largeTitleTextAttributes = largeTitleTextAttributes
        UINavigationBar.appearance().titleTextAttributes = regularTitleTextAttributes
    }
}
