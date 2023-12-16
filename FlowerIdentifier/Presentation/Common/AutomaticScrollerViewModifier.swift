//
//  AutomaticScrollerView.swift
//  writeai
//
//  Created by Eilon Krauthammer on 08/07/2023.
//

import SwiftUI
import SwiftUIIntrospect

struct AutomaticScrollingViewModifier: ViewModifier {
    @Binding var isScrolling: Bool
    @State private var automaticScroller = AutomaticScroller()
    
    func body(content: Content) -> some View {
        content
            .introspect(.scrollView, on: .iOS(.v16, .v17)) { scrollView in
                if automaticScroller.scrollView !== scrollView {
                    automaticScroller.scrollView = scrollView
                }
            }
            .onAppear {
                if isScrolling {
                    automaticScroller.startScrolling()
                }
            }
            .onDisappear {
                automaticScroller.stopScrolling()
            }
            .onChange(of: isScrolling) { isScrolling in
                if isScrolling {
                    automaticScroller.startScrolling()
                } else {
                    automaticScroller.stopScrolling()
                }
            }
    }
}

extension View {
    func automaticallyScrolling(_ isScrolling: Binding<Bool>) -> some View {
        modifier(AutomaticScrollingViewModifier(isScrolling: isScrolling))
    }
    
    func automaticallyScrolling() -> some View {
        modifier(AutomaticScrollingViewModifier(isScrolling: .constant(true)))
    }
}
