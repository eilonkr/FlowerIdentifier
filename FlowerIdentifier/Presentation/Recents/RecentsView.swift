//
//  RecentsView.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthamer on 03/12/2023.
//

import SwiftUI

struct RecentsView: View {
    @EnvironmentObject private var recentItemsStorage: LocalStorage<RecentItem>
    @State private var navigationPath = [MainNavigationPath]()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    ForEach(recentItemsStorage.items, id: \.self) { recentItem in
                        RecentItemView(recentItem: recentItem) {
                            navigationPath.append(.recentItemPlantInfo(recentItem))
                        }
                        .contextMenu {
                            Button(role: .destructive) {
                                recentItemsStorage.delete(recentItem)
                            } label: {
                                Label("Remove", systemImage: "trash")
                            }
                        }
                        .transition(.fade(duration: 0.3))
                    }
                }
                .animation(.smooth(duration: 0.3), value: recentItemsStorage.items)
                .padding(20)
            }
            .overlay {
                if recentItemsStorage.items.isEmpty {
                    emptyStateView()
                }
            }
            .background(Color.background)
            .navigationTitle("My Garden")
            .mainNavigationDestination(navigationPath: $navigationPath)
        }
    }
    
    private func emptyStateView() -> some View {
        VStack(spacing: 12.0) {
            Image(systemName: "books.vertical")
                .font(.system(.largeTitle))
                .fontWeight(.light)
            
            Text("Previously identified plants will be shown here")
                .font(.system(.body, design: .rounded, weight: .medium))
                .multilineTextAlignment(.center)
        }
        .foregroundStyle(Color.subtitle)
        .padding(.horizontal, 30)
    }
}
