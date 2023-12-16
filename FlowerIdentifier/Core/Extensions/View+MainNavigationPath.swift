//
//  View+MainNavigationPath.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthamer on 03/12/2023.
//

import SwiftUI

extension View {
    func mainNavigationDestination(navigationPath: Binding<[MainNavigationPath]>) -> some View {
        navigationDestination(for: MainNavigationPath.self) { path in
            switch path {
            case .plantInfoView(let identificationResponse):
                PlantInfoView(identificationResponse: identificationResponse, navigationPath: navigationPath)
            case .recentItemPlantInfo(let recentItem):
                PlantInfoView(recentItem: recentItem, navigationPath: navigationPath)
            case .chat(let identificationResponse):
                PlantChatView(identificationResponse: identificationResponse)
            }
        }
    }
}
