//
//  PlantSearchView.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthamer on 03/12/2023.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var searchModel = SearchModel()
    @State private var navigationPath = [MainNavigationPath]()
    @State private var searchText = ""
    @State private var showsSearchError = false
    @FocusState private var isSearchFieldFocused
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Text("🌱")
                        .font(.system(size: 52))
                    
                    Text("Search any plant, flower or tree")
                        .font(.system(.headline, design: .rounded, weight: .medium))
                        .foregroundStyle(Color.subtitle)
                    
                    TextField("Search anything", text: $searchText)
                        .textFieldStyle(.plain)
                        .font(.system(.body, design: .rounded, weight: .medium))
                        .focused($isSearchFieldFocused)
                        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                        .frame(height: 40)
                        .background(Color(.quaternarySystemFill))
                        .cornerRadius(style: .regular, strokeColor: Color.separator, strokeWidth: 1)
                }
                
                searchButton()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 52)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color.background
                    .ignoresSafeArea()
                    .onTapGesture {
                        isSearchFieldFocused = false
                    }
            )
            .navigationTitle("Search")
            .mainNavigationDestination(navigationPath: $navigationPath)
            .errorAlert(title: "Something Went Wrong 😕",
                        message: "Please try again or try a different search term",
                        isPresented: $showsSearchError)
            .onAppear {
                searchText = ""
            }
            .onReceive(searchModel.$result) { result in
                switch result {
                case .success(let response):
                    navigationPath.append(.plantInfoView(response))
                case .failure:
                    showsSearchError = true
                case nil:
                    break
                }
            }
        }
    }
    
    private func searchButton() -> some View {
        Button {
            searchModel.search(searchText)
        } label: {
            HStack(spacing: 8) {
                Group {
                    if searchModel.isSearching {
                        ProgressView()
                    } else {
                        Image(systemName: "magnifyingglass")
                    }
                }
                .animation(.linear(duration: 0.25), value: searchModel.isSearching)
                
                Text("Search")
            }
        }
        .ctaButtonStyle(.secondary)
        .disabled(searchText.isEmpty || searchModel.isSearching)
    }
}
