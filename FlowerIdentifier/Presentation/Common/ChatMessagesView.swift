//
//  ChatView.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 09/12/2023.
//

import SwiftUI

struct ChatMessagesView: View {
    let chatItems: [ChatItem]
    
    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(chatItems, id: \.self) { chatItem in
                chatItemView(for: chatItem)
                    .padding(.vertical, 8)
                    .id(chatItem.id)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.smooth(duration: 0.2), value: chatItems)
        .padding(.horizontal, 22)
    }
    
    @ViewBuilder private func chatItemView(for chatItem: ChatItem) -> some View {
        switch chatItem {
        case .message(let chatMessage):
            ChatMessageView(message: chatMessage)
        case .loader:
            LoadingAnimationView(spacing: 4)
                .foregroundStyle(Color.title)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
