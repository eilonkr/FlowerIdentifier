//
//  RemoteConfigService.swift
//  Word Story
//
//  Created by Eilon Krauthammer on 10/06/2021.
//

import Foundation

protocol RemoteConfigClient {
    subscript(_ key: String) -> RemoteConfigValue? { get }
    func activate(completion: (() -> Void)?)
}

class RemoteConfigService {
    static let shared = RemoteConfigService()
    
    private let remoteConfigClient: RemoteConfigClient = FirebaseRemoteConfigService()
    
    private init() { }

    // MARK: - Public
    subscript(_ key: String) -> RemoteConfigValue? {
        return remoteConfigClient[key]
    }
    
    func activate(completion: (() -> Void)? = nil) {
        remoteConfigClient.activate(completion: completion)
    }
}
