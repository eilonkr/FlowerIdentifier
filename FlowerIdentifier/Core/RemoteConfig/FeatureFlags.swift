//
//  FeatureFlags.swift
//  Blurify-V2
//
//  Created by Eilon Krauthammer on 03/11/2022.
//

import Foundation

class FeatureFlags {
    @FeatureFlag("freeIdentifications", defaultValue: 0) static var freeIdentifications
    @FeatureFlag("forceRemoteKey", defaultValue: false) static var forceRemoteKey: Bool
    @FeatureFlag("birthdayParty", defaultValue: "") static var encryptedBase64OpenAIAPIToken
    @FeatureFlag("birthdayParty2", defaultValue: "") static var encodedKey
    @FeatureFlag("isFreeTrialAllowed", defaultValue: false) static var isFreeTrialAllowed
    @FeatureFlag("onboardingCloseButtonShowDuration", defaultValue: 1) static var onboardingCloseButtonShowDuration
    @FeatureFlag("isHighDetailImageInput", defaultValue: false) static var isHighDetailImageInput
    @FeatureFlag("isAIChatAvailable", defaultValue: false) static var isAIChatAvailable
    @FeatureFlag("opensAppStoreReview", defaultValue: false) static var opensAppStoreReview
    @FeatureFlag("openAIAPIPublicKey", defaultValue: "") static var openAIAPIPublicKey
}
