//
//  FirebaseRemoteConfigService.swift
//  ProfilePictureEditor
//
//  Created by Eilon Krauthammer on 23/11/2023.
//

import Firebase

class FirebaseRemoteConfigService: RemoteConfigClient {
    private lazy var remoteConfig: RemoteConfig = {
        let settings = RemoteConfigSettings()
        #if DEBUG
        settings.minimumFetchInterval = 0.0
        #endif
        
        let config = RemoteConfig.remoteConfig()
        config.configSettings = settings
        return config
    }()
    
    subscript(key: String) -> RemoteConfigValue? {
        return remoteConfig[key]
    }
    
    func activate(completion: (() -> Void)?) {
        remoteConfig.fetchAndActivate { _, _ in
            completion?()
        }
    }
}
