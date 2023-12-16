//
//  RemoteConfigValue.swift
//  ProfilePictureEditor
//
//  Created by Eilon Krauthammer on 22/11/2023.
//

import Foundation

protocol RemoteConfigValue {
    var string: String? { get }
    var bool: Bool? { get }
    var float: Float? { get }
    var int: Int? { get }
}
