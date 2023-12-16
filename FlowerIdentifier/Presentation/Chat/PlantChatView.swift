//
//  PlantChatView.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 02/12/2023.
//

import SwiftUI

struct PlantChatView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var chatModel: PlantChatModel
    @State private var inputText: String = ""
    @State private var contentOffset: CGFloat = 0
    private let navigationBarTitleFullOpacityThreshold: Double = 100
    private var identificationResponse: IdentificationResponse {
        return chatModel.identificationResponse
    }
    
    private var isSendButtonEnabled: Bool {
        return inputText.isEmpty == false
    }
    
    private var navigationTitleOpacity: Double {
        let targetOpacity = contentOffset / navigationBarTitleFullOpacityThreshold
        return min(1, max(0, targetOpacity))
    }
    
    init(identificationResponse: IdentificationResponse) {
        _chatModel = StateObject(wrappedValue: PlantChatModel(identificationResponse: identificationResponse))
    }
    
    // MARK: - Views
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                ScrollViewReader { proxy in
                    ObservableScrollView(contentOffset: $contentOffset, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            header()
                                .padding(.bottom, 20)
                            
                            ChatMessagesView(chatItems: chatModel.chatItems)
                        }
                        .padding(.vertical, 20)
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .onReceive(chatModel.$chatItems) { chatItems in
                        if let lastChatItem = chatItems.last {
                            DispatchQueue.main.async {
                                withAnimation {
                                    proxy.scrollTo(lastChatItem.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                }
                
                navigationBar()
            }
            
            composer()
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .background(alignment: .top) {
            Color(.background)
                .overlay {
                    Color.createGradientOverlay()
                        .offset(y: -140)
                }
                .ignoresSafeArea()
        }
        .overlay {
            if chatModel.chatItems.isEmpty {
                emptyStateView()
            }
        }
    }
    
    private func emptyStateView() -> some View {
        VStack(spacing: 16) {
            Text("🌿")
                .font(.system(size: 52))
            
            Text("Ask our AI assistant anything\nabout \(identificationResponse.commonName)\(identificationResponse.commonName.last == "s" ? "" : "s")")
                .multilineTextAlignment(.center)
                .font(.system(.headline, design: .rounded, weight: .medium))
        }
        .foregroundStyle(Color.subtitle)
    }
    
    private func navigationBar() -> some View {
        baseTitleView()
            .font(.system(.title3, design: .rounded, weight: .semibold))
            .opacity(navigationTitleOpacity)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                UIFactory.createBackButton(action: dismiss.callAsFunction)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(
                .thinMaterial
                    .opacity(navigationTitleOpacity)
            )
    }
    
    private func header() -> some View {
        baseTitleView(showBadge: true)
            .font(.system(.largeTitle, design: .rounded, weight: .bold))
            .kerning(1.0)
            .padding(.horizontal)
            .padding(.top, 40)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func baseTitleView(showBadge: Bool = false) -> some View {
        HStack(spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                Text("AI Chat")
            }
            
            if showBadge {
                UIFactory.createBadge(text: "NEW")
                    .font(.system(.caption, design: .rounded, weight: .bold))
                    .offset(y: 3)
            }
        }
        .foregroundStyle(Color.title)
    }
    
    private func composer() -> some View {
        HStack(alignment: .bottom, spacing: 0) {
            TextField("Ask Anything...", text: $inputText, axis: .vertical)
                .lineLimit(5)
                .font(.system(.body, design: .rounded, weight: .medium))
                .foregroundStyle(Color.title)
                .textFieldStyle(.plain)
                .frame(minHeight: 36)
                .padding(.leading, 16)
            
            Button(action: sendTapped) {
                Image(systemName: "paperplane.fill")
                    .font(.system(.title3, weight: .bold))
                    .foregroundStyle(Color.title)
                    .rotationEffect(.degrees(45))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
            }
            .springButtonStyle()
            .disabled(!isSendButtonEnabled || chatModel.isLoadingResponse)
        }
        .padding(.vertical, 8)
        .background(
            Color(.tertiarySystemBackground)
                .ignoresSafeArea()
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(Color.separator)
                        .frame(height: 1)
                }
        )
    }
    
    // MARK: - Private
    private func sendTapped() {
        chatModel.send(inputText)
        inputText = ""
    }
}
