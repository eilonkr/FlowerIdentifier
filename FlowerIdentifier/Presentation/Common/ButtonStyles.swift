//
//  ButtonStyles.swift
//  writeai
//
//  Created by Eilon Krauthammer on 27/05/2023.
//

import SwiftUI
import EKAppFramework

struct CTAButtonStyle: ButtonStyle {
    enum Size: Equatable {
        case regular
        case large
        case custom(height: CGFloat, font: Font = .system(.body, design: .rounded, weight: .semibold))
        
        var height: CGFloat {
            return switch self {
            case .regular:
                38
            case .large:
                50
            case .custom(let height, _):
                height
            }
        }
        
        var font: Font {
            return switch self {
            case .regular:
                .system(.body, design: .rounded, weight: .semibold)
            case .large:
                .system(.headline, design: .rounded, weight: .semibold)
            case .custom(_, let font):
                font
            }
        }
    }
    
    enum CTAType {
        case primary
        case secondary
        
        @ViewBuilder var background: some View {
            switch self {
            case .primary:
                Color.active
            case .secondary:
                Color(.tertiarySystemFill)
            }
        }
        
        var foregroundColor: Color {
            return .title
//            return switch self {
//            case .primary:
//                .white
//            case .secondary:
//                .title
//            }
        }
    }
    
    let type: CTAType
    let size: Size
    
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .kerning(0.64)
            .frame(maxWidth: size == .large ? .infinity : nil)
            .frame(height: size.height)
            .font(size.font)
            .foregroundColor(configuration.role == .destructive ? Color(.systemRed).opacity(0.9) : type.foregroundColor)
            .padding(.horizontal, 22)
            .background(type.background)
            .clipShape(Capsule(style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.linear(duration: 0.1), value: configuration.isPressed)
            .opacity(isEnabled ? 1 : 0.42)
    }
}

struct NavigationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.title)
            .font(.footnote)
            .padding(4)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.linear(duration: 0.1), value: configuration.isPressed)
    }
}

struct SpringButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.linear(duration: 0.1), value: configuration.isPressed)
            .opacity(isEnabled ? 1 : 0.62)
    }
}

extension View {
    func ctaButtonStyle(_ type: CTAButtonStyle.CTAType, size: CTAButtonStyle.Size = .regular) -> some View {
        buttonStyle(CTAButtonStyle(type: type, size: size))
    }
    
    func springButtonStyle() -> some View {
        buttonStyle(SpringButtonStyle())
    }
    
    func navigationButtonStyle() -> some View {
        buttonStyle(NavigationButtonStyle())
    }
}
