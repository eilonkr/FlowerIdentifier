//
//  HTTPClient.swift
//  writeai
//
//  Created by Eilon Krauthammer on 14/07/2023.
//

import Foundation

class HTTPClient {
    static func get<T: Decodable>(_ urlString: String,
                                  headers: [String: String] = [:],
                                  queryParams: [String: String]? = nil) async throws -> T {
        guard var urlComponents = URLComponents(string: urlString) else {
            throw URLError(.badURL)
        }
        
        if let queryParams {
            urlComponents.queryItems = queryParams.map(URLQueryItem.init)
        }
        
        let url = urlComponents.url!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        for (name, value) in headers {
            urlRequest.setValue(value, forHTTPHeaderField: name)
        }
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        data.debugPrintJSON()
        
        let result = try JSONDecoder().decode(T.self, from: data)
        return result
    }
}

private extension Data {
    func debugPrintJSON(function: String = #function) {
        #if DEBUG
        let json = try? JSONSerialization.jsonObject(with: self) as? [String: Any]
        if let json {
            print(String(data: try! JSONSerialization.data(withJSONObject: json,
                                                           options: .prettyPrinted),
                         encoding: .utf8)!)
        } else {
            print("\(function): json is nil")
        }
        #endif
    }
}
