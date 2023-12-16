//
//  ChatGPTAPIWrapper.swift
//  writeai
//
//  Created by Eilon Krauthammer on 03/11/2023.
//

import Foundation
import CryptoKit
import ChatGPTSwift

class ChatGPTAPIWrapper {
    private var chatGPTAPI: ChatGPTAPI?
    private let pollingSeconds: TimeInterval = 2
        
    func getAPI() async -> ChatGPTAPI {
        if let chatGPTAPI {
            return chatGPTAPI
        }
        
        let encryptedBase64APIKey = FeatureFlags.encryptedBase64OpenAIAPIToken
        guard encryptedBase64APIKey.isEmpty == false else {
            try? await Task.sleep(for: .seconds(pollingSeconds))
            return await getAPI()
        }
        
        let encodedKey = FeatureFlags.forceRemoteKey ? FeatureFlags.encodedKey : Constants.Secrets.encodedEncryptedAPITokenKey
        let decryptedAPIKey = try! decrypt(encryptedBase64EncodedToken: encryptedBase64APIKey,
                                           encodedKey: encodedKey)
        let api = ChatGPTAPI(apiKey: decryptedAPIKey)
        self.chatGPTAPI = api
        
        return api
    }
    
    private func decrypt(encryptedBase64EncodedToken: String, encodedKey: String) throws -> String {
        let key = SymmetricKey(data: Data(base64Encoded: encodedKey)!)
        let encryptedTokenData = Data(base64Encoded: encryptedBase64EncodedToken)!
        let sealedBox = try AES.GCM.SealedBox(combined: encryptedTokenData)
        let decryptedTokenData = try AES.GCM.open(sealedBox, using: key)
        let decryptedToken = String(data: decryptedTokenData, encoding: .utf8)!
        
        return decryptedToken
    }
}
