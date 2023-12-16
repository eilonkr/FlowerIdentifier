//
//  AnalyticsService.swift
//  
//
//  Created by Eilon Krauthammer on 15/01/2023.
//

import Firebase

public struct AnalyticsService {
    public static func logEvent(name: String, value: Any? = .none) {
        var params: [String: Any]?
        if let val = value {
            params = ["value": val]
        }
        
        Analytics.logEvent(name, parameters: params)
    }
    
    public static func logEvent(name: String, params: [String: Any]? = .none) {
        Analytics.logEvent(name, parameters: params)
    }
}

