//
//  PreviewView.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 28/11/2023.
//

import SwiftUI

struct PreviewView: View {
    let image: Image
    let aspectRatio: CGFloat
    
    var body: some View {
        image
            .resizable()
            .aspectRatio(aspectRatio, contentMode: .fit)
    }
}
