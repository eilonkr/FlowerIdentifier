//
//  AppModel.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 02/12/2023.
//

import Foundation

class AppModel: ObservableObject {
    @Published var showsSubscription = false
    @Published var showsSettings = false
    @Published var showsDebugMenu = false
}
