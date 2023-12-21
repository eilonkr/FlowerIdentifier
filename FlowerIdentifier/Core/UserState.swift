//
//  UserState.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 02/12/2023.
//

import SwiftUI
import EKAppFramework

enum UserStateSharedKey: String {
    case mockGPTResponse
}

class UserState: ObservableObject, UserStateProtocol {
    @AppStorage("didSeeOnboarding") var didSeeOnboarding = false
    @AppStorage("isSubscribed") var isSubscribed = false
    @AppStorage("userReceipt") var userReceipt: String?
    @AppStorage("numberOfEntries") var numberOfEntries = 0
    @AppStorage("didRequestReview") var didResponsePositivelyToReviewRequest = false
    @AppStorage(UserStateSharedKey.mockGPTResponse.rawValue) var mockGPTResponse = false
    @AppStorage("resetTipsOnNextLaunch") var resetTipsOnNextLaunch = false
    @AppStorage("godModeEnabled") var godModeEnabled = false
    @AppStorage("numberOfPredictions") var numberOfIdentifications = 0
    @AppStorage("preferredLanguage") var preferredLanguage = Language.languages.first
    
    var isEligibleForOutput: Bool {
        if isSubscribed {
            return true
        }
        
        return numberOfIdentifications < FeatureFlags.freeIdentifications
    }
    
    var shouldRequestReview: Bool {
        return numberOfIdentifications == 1 || numberOfIdentifications % 3 == 0
    }
}
