//
//  FlowerIdentifierApp.swift
//  FlowerIdentifier
//
//  Created by Eilon Krauthammer on 16/12/2023.
//

import SwiftUI
import Firebase
import SDWebImage

@main
struct FlowerIdentifierApp: App {
    @StateObject private var userState = UserState()
    
    init() {
        setupServices()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(userState)
        }
    }
    
    // MARK: - Private
    private func setupServices() {
        FirebaseApp.configure()
        RemoteConfigService.shared.activate()
        configureSDImageCache()
    }
    
    private func configureSDImageCache() {
        SDImageCache.shared.config.maxMemoryCost = 500 * 1024 * 1024
        SDImageCache.shared.config.maxDiskSize = 60 * 1024 * 1024
    }
}
