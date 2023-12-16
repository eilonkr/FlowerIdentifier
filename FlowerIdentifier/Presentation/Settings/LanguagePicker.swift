//
//  LanguagePicker.swift
//  writeai
//
//  Created by Eilon Krauthammer on 24/06/2023.
//

import SwiftUI

struct LanguagePicker: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selection: Language?
    @State private var searchText = ""
    
    private var languageSearchResults: [Language] {
        let allLanguages = Language.languages
        return searchText.isEmpty ? allLanguages : allLanguages.filter {
            $0.name.contains(searchText) || $0.localName.contains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(languageSearchResults, id: \.self) { language in
                    languageItemView(language: language)
                }
            }
            .navigationTitle("Output language")
        }
        .searchable(text: $searchText)
    }
    
    private func languageItemView(language: Language) -> some View {
        Button {
            selection = language
            dismiss()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(language.name)
                    
                    Text(language.localName)
                        .foregroundColor(.subtitle)
                        .font(.caption)
                }
                .foregroundColor(.title)
                
                Spacer()
                
                if language == selection {
                    Image(systemName: "checkmark")
                        .foregroundColor(.active)
                        .font(.callout)
                        .fontWeight(.medium)
                }
            }
            .contentShape(Rectangle())
        }
        .commonButtonStyle()
    }
}
