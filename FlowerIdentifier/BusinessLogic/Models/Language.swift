//
//  Language.swift
//  writeai
//
//  Created by Eilon Krauthammer on 24/06/2023.
//

import Foundation

struct Language: Codable, Hashable {
    static let languages = createLanguages()
    
    let localeId: String
    let name: String
    let localName: String
    
    static private func createLanguages() -> [Language] {
        var languages = [Language]()
        var locales = NSLocale.availableLocaleIdentifiers.sorted()
        locales.insert(contentsOf: NSLocale.preferredLanguages, at: 0)
        locales.insert("en-US", at: 0)
        
        for locale in locales {
            let nsLocale = NSLocale(localeIdentifier: locale)
            let test = nsLocale.displayName(forKey: NSLocale.Key.languageCode, value: locale) ?? ""
            let englishSubtitle = NSLocale(localeIdentifier: "en-US").displayName(forKey: NSLocale.Key.languageCode, value: locale) ?? ""
            let lang = Language(localeId: locale, name: test, localName: englishSubtitle)
            if !languages.contains(where: { $0.name == lang.name }) {
                languages.append(lang)
            }
        }
        
        return languages
    }
}
