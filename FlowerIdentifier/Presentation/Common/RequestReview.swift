//
//  ReqestReview.swift
//  NoCropPhoto
//
//  Created by Eilon Krauthammer on 23/09/2023.
//

import SwiftUI

struct RequestReview: ViewModifier {
    @Environment(\.requestReview) private var requestReview
    @EnvironmentObject private var userState: UserState
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        if userState.didResponsePositivelyToReviewRequest == false {
            content
                .alert("Finding Flower Identifier Useful?", isPresented: $isPresented) {
                    Button("Not Now") {
                        AnalyticsService.logEvent(name: "review_request_not_now")
                    }
                    
                    Button("Sure!") {
                        requestReview()
                        AnalyticsService.logEvent(name: "review_request_sure")
                        userState.didResponsePositivelyToReviewRequest = true
                    }
                } message: {
                    Text("Please consider rating our app as it greatly supports us and enables us to keep improving it ❤️")
                }
        } else {
            content
        }
    }
}

extension View {
    func requestsReview(isPresented: Binding<Bool>) -> some View {
        modifier(RequestReview(isPresented: isPresented))
    }
}
