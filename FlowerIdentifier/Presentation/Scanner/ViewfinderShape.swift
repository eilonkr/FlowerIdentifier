//
//  ViewfinderShape.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 08/12/2023.
//

import SwiftUI

struct ViewfinderShape: Shape {
    let insets: UIEdgeInsets
    let lineLength: CGFloat
    let cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        let insetRect = rect.inset(by: insets)
        var path = Path()

        // Top left
        path.move(to: CGPoint(x: insetRect.minX, y: insetRect.minY + lineLength))
        path.addLine(to: CGPoint(x: insetRect.minX, y: insetRect.minY + cornerRadius))
        path.addArc(center: CGPoint(x: insetRect.minX + cornerRadius, y: insetRect.minY + cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(180),
                    endAngle: .degrees(270),
                    clockwise: false)
        path.addLine(to: CGPoint(x: insetRect.minX + lineLength, y: insetRect.minY))

        // Top right
        path.move(to: CGPoint(x: insetRect.maxX, y: insetRect.minY + lineLength))
        path.addLine(to: CGPoint(x: insetRect.maxX, y: insetRect.minY + cornerRadius))
        path.addArc(center: CGPoint(x: insetRect.maxX - cornerRadius, y: insetRect.minY + cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(0),
                    endAngle: .degrees(-90),
                    clockwise: true)
        path.addLine(to: CGPoint(x: insetRect.maxX - lineLength, y: insetRect.minY))

        // Bottom left
        path.move(to: CGPoint(x: insetRect.minX, y: insetRect.maxY - lineLength))
        path.addLine(to: CGPoint(x: insetRect.minX, y: insetRect.maxY - cornerRadius))
        path.addArc(center: CGPoint(x: insetRect.minX + cornerRadius, y: insetRect.maxY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(180),
                    endAngle: .degrees(90),
                    clockwise: true)
        path.addLine(to: CGPoint(x: insetRect.minX + lineLength, y: insetRect.maxY))

        // Bottom right
        path.move(to: CGPoint(x: insetRect.maxX, y: insetRect.maxY - lineLength))
        path.addLine(to: CGPoint(x: insetRect.maxX, y: insetRect.maxY - cornerRadius))
        path.addArc(center: CGPoint(x: insetRect.maxX - cornerRadius, y: insetRect.maxY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(0),
                    endAngle: .degrees(90),
                    clockwise: false)
        path.addLine(to: CGPoint(x: insetRect.maxX - lineLength, y: insetRect.maxY))

        return path
    }
}

#Preview {
    ViewfinderShape(insets: .init(top: 20, left: 20, bottom: 160, right: 20), lineLength: 60, cornerRadius: 15)
        .stroke(Color.blue,
                style: StrokeStyle(lineWidth: 10, lineCap: .round))
}
