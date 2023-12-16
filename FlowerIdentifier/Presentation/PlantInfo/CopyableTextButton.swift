//
//  CopyableTextButton.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthamer on 03/12/2023.
//

import SwiftUI
import EKSwiftSuite

struct CopyableTextButton: View {
    let text: String
    let textToCopy: String
    @State private var isCopied = false
    
    init(text: String, textToCopy: String? = nil) {
        self.text = text
        self.textToCopy = textToCopy ?? text
    }
    
    var body: some View {
        Button {
            isCopied = true
            UIPasteboard.general.string = textToCopy
            Haptic.notification(.success).generate()
        } label: {
            HStack {
                Text(text)
                Spacer()
                
                Image(systemName: isCopied ? "checkmark" : "doc.on.doc.fill")
                    .foregroundStyle(Color.subtitle)
                    .font(.system(.callout, weight: .bold))
                    .frame(height: 22)
                    .animation(.bouncy(duration: 0.2), value: isCopied)
            }
            .padding(12)
            .background(Color(.quaternarySystemFill))
            .cornerRadius(style: .small)
        }
        .springButtonStyle()
        .task(id: isCopied) {
            if isCopied {
                AnalyticsService.logEvent(name: "copy_tapped", value: textToCopy)
                try? await Task.sleep(for: .seconds(2))
                isCopied = false
            }
        }
    }
}
