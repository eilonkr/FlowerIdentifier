//
//  ChatMessageView.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 02/12/2023.
//

import SwiftUI
import EKSwiftSuite

struct ChatMessageView: View {
    let message: ChatMessage
    @State private var isCopied = false
    
    var body: some View {
        Button {
            guard message.sentBy == .ai else {
                return
            }
            
            isCopied = true
            UIPasteboard.general.string = message.text
            Haptic.notification(.success).generate()
        } label: {
            HStack(alignment: .bottom, spacing: 20) {
                Text(message.text)
                    .font(.system(.body, design: .rounded, weight: .regular))
                    .foregroundStyle(Color.title)
                
                if message.sentBy == .ai {
                    Image(systemName: isCopied ? "checkmark" : "doc.on.doc.fill")
                        .foregroundStyle(Color.subtitle)
                        .font(.system(.callout, design: .rounded, weight: .bold))
                        .frame(width: 22, height: 22)
                        .animation(.bouncy(duration: 0.2), value: isCopied)
                }
            }
            .padding(12)
            .background(message.sentBy == .user ? .clear : Color(.quaternarySystemFill))
            .cornerRadius(style: .large)
            .frame(maxWidth: .infinity, alignment: message.sentBy == .user ? .trailing : .leading)
        }
        .modify { view in
            if message.sentBy == .ai {
                view.springButtonStyle()
            } else {
                view.buttonStyle(.plain)
            }
        }
        .task(id: isCopied) {
            if isCopied {
                try? await Task.sleep(for: .seconds(2))
                isCopied = false
            }
        }
    }
}

