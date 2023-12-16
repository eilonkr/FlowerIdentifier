//
//  ObservableScrollView.swift
//  write ai
//
//  Created by Eilon Krauthammer Industries Inc. on 11/02/2022.
//

import SwiftUI

public protocol ObservableScrollProtocol {
    func scrollViewDidScroll(contentOffset: CGFloat, viewSize: CGSize, contentSize: CGSize)
}

public struct ScrollOffsetPreferenceKey: PreferenceKey {
    public static var defaultValue: [CGFloat] = [0]
    
    public static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}

public struct ObservableScrollView<Content>: View where Content: View {
    let axes: Axis.Set
    let showsIndicators: Bool
    
    @Binding var contentOffset: CGFloat
    private let content: Content
    
    //MARK: - Lifecycle
    public init(_ axes: Axis.Set = .vertical,
                contentOffset: Binding<CGFloat>,
                showsIndicators: Bool = true,
                @ViewBuilder content: () -> Content) {
        self.axes = axes
        self._contentOffset = contentOffset
        self.showsIndicators = showsIndicators
        self.content = content()
    }
    
    //MARK: - Views
    public var body: some View {
        GeometryReader { outsideProxy in
            ScrollView(axes, showsIndicators: showsIndicators) {
                ZStack(alignment: axes == .vertical ? .top : .leading) {
                    GeometryReader { insideProxy in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self,
                                        value: [calculateContentOffset(from: outsideProxy, insideProxy: insideProxy)])
                            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { values in
                                guard let value = values.first else {
                                    return
                                }
                                
                                DispatchQueue.main.async {
                                    contentOffset = value
                                }
                            }
                    }
                    VStack {
                        content
                    }
                }
            }
        }
    }
    
    //MARK: - Private
    private func calculateContentOffset(from outsideProxy: GeometryProxy, insideProxy: GeometryProxy) -> CGFloat {
        if axes == .vertical {
            return outsideProxy.frame(in: .global).minY - insideProxy.frame(in: .global).minY
        } else {
            return outsideProxy.frame(in: .global).minX - insideProxy.frame(in: .global).minX
        }
    }
}
