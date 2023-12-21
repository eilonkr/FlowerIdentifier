//
//  OnboardingChatView.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 08/12/2023.
//

import SwiftUI

struct OnboardingChatView: View {
    let onFinish: () -> Void
    
    var body: some View {
        VStack(spacing: 34) {
            DemoChatView()
                .frame(maxWidth: 500, maxHeight: 500)
                .scaleEffect(1.2)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top)
            
            VStack(spacing: 16) {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                    Text("AI Assistant")
                }
                .font(.system(.title2, design: .rounded, weight: .bold))
                .kerning(0.3)
                .foregroundStyle(Color.title.opacity(0.85))
                
                Text("Ask our AI assistant anything about\nyour plants.")
                    .font(.system(.body, design: .rounded, weight: .medium))
                    .multilineTextAlignment(.center)
            }
            
            PrimaryCTAButton(action: onFinish)
                .frame(height: 80, alignment: .top)
                .frame(maxWidth: 500)
        }
    }
}

private struct DemoChatView: View {
    @State private var demoChatItems = [ChatItem]()
    private let totalSections = 4
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                ChatMessagesView(chatItems: demoChatItems)
                    .padding(.vertical, 16)
            }
            .mask(
                LinearGradient(stops: [.init(color: .black, location: 0.9),
                                       .init(color: .black.opacity(0), location: 1)],
                               startPoint: .bottom,
                               endPoint: .top)
            )
            .onChange(of: demoChatItems) { items in
                if let lastChatItem = items.last {
                    withAnimation {
                        proxy.scrollTo(lastChatItem.id)
                    }
                }
            }
        }
        .padding(.top, 20)
        .task {
            await buildMessages(index: 0)
            demoChatItems = []
            await buildMessages(index: 1)
        }
    }
    
    private func buildMessages(index: Int) async {
        try? await Task.sleep(for: .seconds(0.5))
        
        if index == 0 {
            let userMessage = ChatMessage(text: "How often should I water my Orchid flower?", sentBy: .user)
            demoChatItems.append(.message(userMessage))
            
            try? await Task.sleep(for: .seconds(0.5))
            demoChatItems.append(.loader)
            
            try? await Task.sleep(for: .seconds(1.75))
            let aiMessage = ChatMessage(text: "Water orchids when the growing medium is dry, roots are silvery-green, and the pot feels light. Ensure good drainage, adjust based on orchid type, and avoid overwatering.", sentBy: .ai)
            demoChatItems[demoChatItems.count - 1] = .message(aiMessage)
            try? await Task.sleep(for: .seconds(1.75))
        } else if index == 1 {
            let userMessage2 = ChatMessage(text: "What could be signs of over-watering?", sentBy: .user)
            demoChatItems.append(.message(userMessage2))
            
            try? await Task.sleep(for: .seconds(0.5))
            demoChatItems.append(.loader)
            
            try? await Task.sleep(for: .seconds(1.5))
            let aiMessage2 = ChatMessage(text: "Signs of over-watering in orchids include yellowing leaves, root rot (dark and mushy roots), fungus or mold growth, wilting despite excess moisture, and a lack of new growth.", sentBy: .ai)
            demoChatItems[demoChatItems.count - 1] = .message(aiMessage2)
        }
    }
}
