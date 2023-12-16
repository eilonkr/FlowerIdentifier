//
//  PlantHealth.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 28/11/2023.
//

import SwiftUI

struct PlantHealth: Hashable, Codable {
    let status: PlantHealthStatus
    let problems: [String]?
}

enum PlantHealthStatus: String, Codable {
    case excellent
    case good
    case ok
    case sick
    case verySick
    
    var title: String {
        return switch self {
        case .excellent:
            "Excellent"
        case .good:
            "Good"
        case .ok:
            "OK"
        case .sick:
            "Sick"
        case .verySick:
            "Very Sick"
        }
    }
    
    var textColor: Color {
        return switch self {
        case .ok:
            .black
        default:
            .white
        }
    }
    
    var color: Color {
        switch self {
        case .excellent:
            return Color(uiColor: UIColor(hex: "43A047"))
        case .good:
            return Color(uiColor: UIColor(hex: "7CB342"))
        case .ok:
            return Color(uiColor: UIColor(hex: "FFD600"))
        case .sick:
            return Color(uiColor: UIColor(hex: "FF7043"))
        case .verySick:
            return Color(uiColor: UIColor(hex: "FF5252"))
        }
    }
}
