//
//  DisplayPostsStorage.swift
//  socialboost
//
//  Created by Eilon Krauthammer on 27/04/2023.
//

import Foundation
import SwiftUI

protocol LocallyStorable: Codable, Hashable {
    static var storageId: String { get }
}

class LocalStorage<Item: LocallyStorable>: ObservableObject {
    @Published private(set) var items: [Item] = [] {
        didSet {
            guard oldValue != items else {
                return
            }
            
            saveToStorage()
        }
    }
    
    @AppStorage(Item.storageId) private var storageData: Data?
    
    init() {
        items = itemsFromStorage()
    }
    
    func save(_ item: Item) {
        guard items.contains(item) == false else {
            return
        }
        
        items.insert(item, at: 0)
    }
    
    func delete(_ item: Item) {
        items.removeAll { $0 == item }
    }
    
    private func itemsFromStorage() -> [Item] {
        guard let storageData else {
            return []
        }
        
        let posts = try? JSONDecoder().decode([Item].self, from: storageData)
        return posts ?? []
    }
    
    private func saveToStorage() {
        let encodedPosts = try? JSONEncoder().encode(items)
        storageData = encodedPosts
    }
}
