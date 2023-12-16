//
//  UIDeviceOrientation+AVCaptureVideoOrientation.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 28/11/2023.
//

import UIKit
import AVFoundation

extension UIDeviceOrientation {
    var avCaptureVideoOrientation: AVCaptureVideoOrientation? {
        return switch self {
        case .portrait:
            AVCaptureVideoOrientation.portrait
        case .portraitUpsideDown:
            AVCaptureVideoOrientation.portraitUpsideDown
        case .landscapeLeft:
            AVCaptureVideoOrientation.landscapeRight
        case .landscapeRight:
            AVCaptureVideoOrientation.landscapeLeft
        default:
            nil
        }
    }
}
