//
//  Font+Extension.swift
//  writeai
//
//  Created by Eilon Krauthammer on 27/05/2023.
//

import SwiftUI

extension Font {
    public static func system(size: CGFloat,
                              weight: UIFont.Weight,
                              width: UIFont.Width) -> Font {
        return Font(UIFont.systemFont(ofSize: size,
                                      weight: weight,
                                      width: width))
    }
}
