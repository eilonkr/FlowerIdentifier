//
//  GPTMockService.swift
//  writeai
//
//  Created by Eilon Krauthammer on 27/05/2023.
//

import Foundation
import ChatGPTSwift

class GPTMockService: GPTServiceProtocol {
    private let fullString = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Viverra mauris in aliquam sem fringilla ut morbi tincidunt augue. Vestibulum sed arcu non odio euismod lacinia at quis risus. Feugiat pretium nibh ipsum consequ\n\nat nisl vel pretium lectus quam. Augue mauris augue neque gravida in fermentum et sollicitudin. Platea dictumst quisque sagittis purus sit amet volutpat consequat. In metus vulputate eu scelerisque felis. Amet mauris commodo quis imperdiet massa. Et leo duis ut diam quam. Etiam tempor orci eu lobortis elementum nibh tellus. Cursus eget nunc scelerisque viverra. Dolor sit amet consectetur adipiscing elit ut. Consequat ac felis donec et. Elit ut aliquam purus sit amet luctus. Augue mauris augue neque gravida in fermentum et sollicitudin. Platea dictumst quisque sagittis purus sit amet volutpat consequat. In metus vulputate eu scelerisque felis. Amet mauris commodo quis imperdiet massa.\n\n\nEt leo duis ut diam quam. Etiam tempor orci eu lobortis elementum nibh tellus. Cursus eget nunc scelerisque viverra. Dolor sit amet consectetur adipiscing elit ut. Consequat ac felis donec et. Elit ut aliquam purus sit amet luctus, Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Viverra mauris in aliquam sem fringilla ut morbi tincidunt augue. Vestibulum sed arcu non odio euismod lacinia at quis risus. Feugiat pretium nibh ipsum consequat nisl vel pretium lectus quam. Augue mauris augue neque gravida in fermentum et sollicitudin. Platea dictumst quisque sagittis purus sit amet volutpat consequat. In metus vulputate eu scelerisque felis. Amet mauris commodo quis imperdiet massa. Et leo duis ut diam quam. Etiam tempor orci eu lobortis elementum nibh tellus. Cursus eget nunc scelerisque viverra. Dolor sit amet consectetur adipiscing elit ut. Consequat ac felis donec et. Elit ut aliquam purus sit amet luctus. Augue\n mauris augue neque gravida in fermentum et sollicitudin. Platea dictumst quisque sagittis purus sit amet volutpat consequat. In metus vu\n\n\nlputate eu scelerisque felis. Amet mauris commodo quis imperdiet massa. Et leo duis ut diam quam. Etiam tempor orci eu lobortis elementum nibh tellus. Cursus eget nunc scelerisque viverra. Dolor sit amet consectetur adipiscing elit ut. Consequat ac felis donec et. Elit ut aliquam\n\n purus sit amet luctus"
    
    func sendChatMessage(text: String,
                     model: GPTModel,
                     temperature: Double) async throws -> String {
        try await Task.sleep(for: .seconds(2))
        return fullString
    }
    
    func sendIdentificationMessage(input: ImageInput, 
                                   model: GPTModel,
                                   language: String,
                                   temperature: Double) async throws -> IdentificationResponse {
        try await Task.sleep(for: .seconds(2))
        let json = Data(exampleJSONString().utf8)
        let mockResponse = try! JSONDecoder().decode(IdentificationResponse.self, from: json)
        
        return mockResponse
    }
    
    private func exampleJSONString() -> String {
        """
        {
            "name": "Sunflower",
            "scientificName": "Helianthus annuus",
            "description": "Sunflowers are tall, bright, and cheerful flowers that follow the sun throughout the day. They are known for their large, yellow blooms and are a symbol of positivity.",
            "health": {
                "status": "ok",
                "problems": [
                    "Flowers are dying, make sure no overwatering."
                ]
            },
            "temperatureRange": "18 - 30 ºC / 52 - 68 ºF",
            "geography": "North America & Europe",
            "sunlight": "Partial Sun",
            "rarityIndex": "Very Rare",
            "careInstructions": [
                "Plant in well-drained soil with full sunlight exposure",
                "Water regularly, keeping the soil consistently moist but not waterlogged",
                "Support tall stems with stakes to prevent bending or breaking",
                "Fertilize with a balanced fertilizer during the growing season"
            ]
        }
        """
    }
}
