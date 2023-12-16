//
//  FIRRemoteConfigValue+Extension.swift
//  ProfilePictureEditor
//
//  Created by Eilon Krauthammer on 24/11/2023.
//

import Firebase

extension Firebase.RemoteConfigValue: RemoteConfigValue {
    var bool: Bool? {
        guard source == .remote else {
            return nil
        }
            
        return boolValue
    }
    
    var float: Float? {
        guard source == .remote else {
            return nil
        }
        
        return numberValue.floatValue
    }
    
    var int: Int? {
        guard source == .remote else {
            return nil
        }
        
        return numberValue.intValue
    }
    
    var string: String? {
        guard source == .remote else {
            return nil
        }
        
        return stringValue
    }
}
