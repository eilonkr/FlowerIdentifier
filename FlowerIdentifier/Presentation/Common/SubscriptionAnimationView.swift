//
//  SubscriptionAnimationView.swift
//  writeai
//
//  Created by Eilon Krauthammer on 08/07/2023.
//

import SwiftUI

struct SubscriptionAnimationView: View {
    private static let baseEmojis = ["🌼", "☘️", "🍄", "🪷", "🌺", "🌻", "🌷", "🌸", "🪻"]
    private static func createEmojis() -> [String] {
        return baseEmojis.shuffled() + baseEmojis.shuffled() + baseEmojis.shuffled() + baseEmojis.shuffled() + baseEmojis.shuffled()
    }
    
    let numberOfRows: Int
    let emojiSize: CGFloat
    @State private var emojis = Self.createEmojis()
    
    init(numberOfRows: Int = 2, emojiSize: CGFloat = 50) {
        self.numberOfRows = numberOfRows
        self.emojiSize = emojiSize
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            BubbleLayout(horizontalSpacing: 40,
                         verticalSpacing: 12,
                         horizontalOffset: 40,
                         verticalOffset: 0,
                         numberOfRows: numberOfRows) {
                ForEach(0 ..< emojis.count, id: \.self) { index in
                    EmojiView(emoji: emojis[index], emojiSize: emojiSize)
                }
            }
            .padding(.horizontal, -12)
        }
        .automaticallyScrolling()
        .disabled(true)
    }
}

private struct EmojiView: View {
    let emoji: String
    let emojiSize: CGFloat
    var rotationDegreesAngle: CGFloat = 18.0
    
    var body: some View {
        Text(emoji)
            .font(.system(size: emojiSize))
            .rotationEffect(.degrees(rotationDegreesAngle))
            .opacity(0.65)
    }
}
