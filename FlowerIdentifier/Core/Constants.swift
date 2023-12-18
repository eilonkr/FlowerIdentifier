//
//  Constants.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 28/11/2023.
//

import Foundation
import EmailComposer

struct Constants {
    struct URLs {
        //static let appstoreURL: String? = "https://apps.apple.com/app/write-ai-writing-assistant/id6450653057"
        static let contactURL = "mailto:eilonkrauthammer@gmail.com"
        static let privacyPolicyURLString = "https://docs.google.com/document/d/1hAbRgortW7j7ONB6_qZHVBMt1uE4dv394nkeZhSO-4Q/edit?usp=sharing"
        static let termsOfServiceURLString = "https://docs.google.com/document/d/1YR3n0AHXajkWXkPnbf2JQkrhIBmxzmOUtDAz2KsLNzE/edit?usp=sharing"
    }
    
    struct Camera {
        static let photoAspectRatio: CGFloat = 3/4
    }
    
    struct Secrets {
        static let encodedEncryptedAPITokenKey = "ji0FTjWaviH4FHwOu09kDIMvYhgLc5Iwjv1IKk3dPi8="
    }
    
    struct Email {
        static let emailData = EmailData(subject: "Feature / Improvement Request for Flower Identifier",
                                         recipients: ["eilonkrauthammer@gmail.com"],
                                         body: "<Please add your request here>")
    }
}
