//
//  DebugMenuView.swift
//  Blurify-V2
//
//  Created by Eilon Krauthammer on 15/10/2022.
//

import SwiftUI

struct DebugMenuView: View {
    @EnvironmentObject var userState: UserState
    
    var body: some View {
        NavigationStack {
            Form {
                Toggle("Override isSubscribed", isOn: $userState.isSubscribed)
                Toggle("Seen onboarding", isOn: $userState.didSeeOnboarding)
                Toggle("Mock GPT response", isOn: $userState.mockGPTResponse)
                Toggle("Reset tips on next launch", isOn: $userState.resetTipsOnNextLaunch)
            }
        }
        .presentationDetents([.fraction(0.4), .large])
    }
}
