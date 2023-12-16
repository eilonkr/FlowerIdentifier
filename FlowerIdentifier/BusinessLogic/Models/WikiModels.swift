//
//  WikiModels.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 29/11/2023.
//

import Foundation

struct WikiModels {
    struct WikiPageIdSearchResult: Decodable {
        struct Query: Decodable {
            let search: [Page]
        }
        
        struct Page: Decodable {
            let pageid: Int
        }
        
        let query: Query
    }
    
    struct WikiImageDataResult: Decodable {
        struct QueryPages: Decodable {
            struct ImageData: Decodable {
                struct ImageInfo: Decodable {
                    let url: String
                    let width: Int
                    let height: Int
                }
                
                let title: String
                let imageinfo: [ImageInfo]
            }
            
//            struct ImageInfoContainer: Decodable {
//                let imageData: [ImageData]
//                
//                init(from decoder: Decoder) throws {
//                    imageData = try decoder.decodeMultipleDynamicTitledElements(ImageData.self)
//                }
//            }
            
            let pages: [String: ImageData]
        }
        
        let query: QueryPages
    }
}

//struct TitleKey: CodingKey {
//    let stringValue: String
//    init?(stringValue: String) { self.stringValue = stringValue }
//    var intValue: Int? { return nil }
//    init?(intValue: Int) { return nil }
//}
//
//extension Decoder {
//
//    /*
//     * Decode map into object array that is type of Element
//     * [Key: Element] -> [Element]
//     * This will be used when the keys are dynamic and have multiple keys
//     * Within type Element we can embed relevant Key using => 'try decoder.currentTitle()'
//     * So you can access Key using => 'element.key'
//     */
//    func decodeMultipleDynamicTitledElements<Element: Decodable>(_ type: Element.Type) throws -> [Element] {
//        var decodables: [Element] = []
//        let titles = try container(keyedBy: TitleKey.self)
//        for title in titles.allKeys {
//            if let element = try? titles.decode(Element.self, forKey: title) {
//                decodables.append(element)
//            }
//        }
//        return decodables
//    }
//
//    /*
//     * Decode map into optional object that is type of Element
//     * [Key: Element] -> Element?
//     * This will be used when the keys are dynamic and when you're sure there'll be only one key-value pair
//     * Within type Element we can embed relevant Key using => 'try decoder.currentTitle()'
//     * So you can access Key using => 'element.key'
//     */
//    func decodeSingleDynamicTitledElement<Element: Decodable>(_ type: Element.Type) throws -> Element? {
//        let titles = try container(keyedBy: TitleKey.self)
//        for title in titles.allKeys {
//            if let element = try? titles.decode(Element.self, forKey: title) {
//                return element
//            }
//        }
//        return nil
//    }
//
//    /*
//     * Decode map key-value pair into optional object that is type of Element
//     * Key: Element -> Element?
//     * This will be used when the root key is known, But the value is constructed with Maps where the keys can be Unknown
//     */
//    func decodeStaticTitledElement<Element: Decodable>(with key: TitleKey, _ type: Element.Type) throws -> Element? {
//        let titles = try container(keyedBy: TitleKey.self)
//        if let element = try? titles.decode(Element.self, forKey: key) {
//            return element
//        }
//        return nil
//    }
//
//    /*
//     * This will be used to know where the Element is in the Object tree
//     * Returns the Key of the Element which was mapped to
//     */
//    func currentTitle() throws -> String {
//        guard let titleKey = codingPath.last as? TitleKey else {
//            throw DecodingError.dataCorrupted(.init(codingPath: codingPath, debugDescription: "Not in titled container"))
//        }
//        return titleKey.stringValue
//    }
//}
//
///*
// * Class that implements this Protocol, contains an array of Element Objects,
// * that will be mapped from a 'Key1: [Key2: Element]' type of map.
// * This will be used when the Key2 is dynamic and have multiple Key2 values
// * Key1 -> Key1: TitleDecodable
// * [Key2: Element] -> Key1_instance.elements
// * Key2 -> Key1_instance.elements[index].key2
// */
//protocol TitleDecodable: Decodable {
//    associatedtype Element: Decodable
//    init(title: String, elements: [Element])
//}
//extension TitleDecodable {
//    init(from decoder: Decoder) throws {
//        self.init(title: try decoder.currentTitle(), elements: try decoder.decodeMultipleDynamicTitledElements(Element.self))
//    }
//}
//
///*
// * Class that implements this Protocol, contains a variable which is type of Element,
// * that will be mapped from a 'Key1: [Key2: Element]' type of map.
// * This will be used when the Keys2 is dynamic and have only one Key2-value pair
// * Key1 -> Key1: SingleTitleDecodable
// * [Key2: Element] -> Key1_instance.element
// * Key2 -> Key1_instance.element.key2
// */
//protocol SingleTitleDecodable: Decodable {
//    associatedtype Element: Decodable
//    init(title: String, element: Element?)
//}
//extension SingleTitleDecodable {
//    init(from decoder: Decoder) throws {
//        self.init(title: try decoder.currentTitle(), element: try decoder.decodeSingleDynamicTitledElement(Element.self))
//    }
//}
