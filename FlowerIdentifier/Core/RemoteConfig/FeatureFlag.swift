//
//  FeatureFlag.swift
//  Blurify-V2
//
//  Created by Eilon Krauthammer on 03/11/2022.
//

protocol RemoteConfigConvertible {
    static func value(for remoteConfigValue: RemoteConfigValue) -> Self?
}

@propertyWrapper struct FeatureFlag<Value: RemoteConfigConvertible> {
    let key: String
    let defaultValue: Value
    
    public init(_ key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: Value {
        if let remoteConfigValue = RemoteConfigService.shared[key] {
            return Value.value(for: remoteConfigValue) ?? defaultValue
        }
        
        return defaultValue
    }
}

@propertyWrapper struct OptionalFeatureFlag<Value: RemoteConfigConvertible> {
    let key: String
    
    public init(_ key: String) {
        self.key = key
    }
    
    var wrappedValue: Value? {
        if let remoteConfigValue = RemoteConfigService.shared[key] {
            return Value.value(for: remoteConfigValue)
        }
        
        return nil
    }
}
