//
//  RemoteConfigTypes+Extensions.swift
//  ProfilePictureEditor
//
//  Created by Eilon Krauthammer on 22/11/2023.
//

import Foundation

extension Bool: RemoteConfigConvertible {
    static func value(for remoteConfigValue: RemoteConfigValue) -> Bool? {
        return remoteConfigValue.bool
    }
}

extension Int: RemoteConfigConvertible {
    static func value(for remoteConfigValue: RemoteConfigValue) -> Int? {
        return remoteConfigValue.int
    }
}

extension String: RemoteConfigConvertible {
    static func value(for remoteConfigValue: RemoteConfigValue) -> String? {
        return remoteConfigValue.string
    }
}

extension Float: RemoteConfigConvertible {
    static func value(for remoteConfigValue: RemoteConfigValue) -> Float? {
        return remoteConfigValue.float
    }
}
