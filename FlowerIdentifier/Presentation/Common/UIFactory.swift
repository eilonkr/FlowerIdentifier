//
//  UIFactory.swift
//  writeai
//
//  Created by Eilon Krauthammer on 28/05/2023.
//

import SwiftUI

struct UIFactory {
    static func createBackButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 22, weight: .semibold))
                .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 8))
        }
        .springButtonStyle()
    }
    
    static func createCloseButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 16, weight: .semibold))
                .padding(6)
                .background(Color.black.opacity(0.25))
                .clipShape(Circle())
        }
        .springButtonStyle()
    }
    
    static func createBadge(text: String, shadowColor: Color = .black.opacity(0.15), isInverted: Bool = false) -> some View {
        Text(text)
            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            .background {
                if isInverted {
                    Color.white
                } else {
                    AccentGradient()
                }
            }
            .cornerRadius(style: .small)
            .shadow(color: shadowColor, radius: 3, y: 2)
            .modify { view in
                if isInverted {
                    view.foregroundStyle(AccentGradient.gradient)
                } else {
                    view.foregroundStyle(.white)
                }
            }
    }
}
