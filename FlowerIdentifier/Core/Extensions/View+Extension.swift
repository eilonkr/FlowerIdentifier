//
//  View+Extension.swift
//  writeai
//
//  Created by Eilon Krauthammer on 27/05/2023.
//

import SwiftUI

enum CornerRadiusStyle {
    case small
    case regular
    case large
    case circular
    case custom(CGFloat)
    
    var cornerRadius: CGFloat {
        switch self {
        case .small:
            return 6.0
        case .regular:
            return 8.0
        case .large:
            return 10.0
        case .circular:
            return .greatestFiniteMagnitude
        case .custom(let radius):
            return radius
        }
    }
}

extension View {
    func cornerRadius(style: CornerRadiusStyle) -> some View {
        clipShape(RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous))
    }
    
    func cornerRadius(style: CornerRadiusStyle, strokeColor: Color, strokeWidth: CGFloat) -> some View {
        clipShape(RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
                    .stroke(strokeColor, lineWidth: strokeWidth)
            }
    }
    
    func onSizeChange(perform closure: @escaping (CGSize) -> Void) -> some View {
        overlay(GeometryReader { proxy in
            Color.clear
                .onAppear {
                    closure(proxy.size)
                }
                .onChange(of: proxy.size, perform: closure)
        })
    }
    
    func onPositionChange(perform closure: @escaping (CGPoint) -> Void) -> some View {
        overlay(GeometryReader { proxy in
            Color.clear
                .onAppear {
                    let frame = proxy.frame(in: .global)
                    closure(CGPoint(x: frame.midX, y: frame.midY))
                }
                .onChange(of: proxy.frame(in: .global), perform: { frame in
                    closure(CGPoint(x: frame.midX, y: frame.midY))
                })
        })
    }
    
    func viewLoading(_ isLoading: Bool = true) -> some View {
        overlay {
            if isLoading {
                Color(.systemBackground).opacity(0.5)
                    .overlay(ProgressView())
                    .ignoresSafeArea()
            }
        }
        .animation(.linear(duration: 0.25), value: isLoading)
    }
    
    func errorAlert(title: String, message: String, isPresented: Binding<Bool>, action: @escaping () -> Void = { }) -> some View {
        alert(title, isPresented: isPresented, actions: {
            Button("OK", action: action)
        }, message: {
            Text(message)
        })
    }
    
    @ViewBuilder func scaledToFill(aspectRatio: CGFloat?) -> some View {
        if let aspectRatio {
            Rectangle()
                .aspectRatio(aspectRatio, contentMode: .fit)
                .overlay(self)
                .clipped()
        } else {
            self
        }
    }
}
