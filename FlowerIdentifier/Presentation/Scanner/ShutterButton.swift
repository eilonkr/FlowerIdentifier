//
//  ShutterButton.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 28/11/2023.
//

import SwiftUI

struct ShutterButton: View {
    let action: () -> Void
    @GestureState private var isPressed = false
    
    var body: some View {
        outterRing
            .overlay {
                innerCircle
                    .padding(6)
            }
            .frame(width: 60, height: 60)
            .shadow(color: .black.opacity(0.2), radius: 4)
            .onTapGesture(perform: action)
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 5)
                    .updating($isPressed) { currentState, gestureState, transaction in
                        gestureState = currentState
                    }
            )
    }
    
    private var outterRing: some View {
        Circle()
            .stroke(.white, lineWidth: 4)
    }
    
    private var innerCircle: some View {
        Circle()
            .fill(.white)
            .scaleEffect(isPressed ? 0.85 : 1)
            .opacity(isPressed ? 0.9 : 1)
            .animation(.smooth(duration: 0.3), value: isPressed)
    }
}
