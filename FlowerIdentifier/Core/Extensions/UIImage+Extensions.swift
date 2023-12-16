//
//  UIImage+Extensions.swift
//  ProfilePictureEditor
//
//  Created by Eilon Krauthammer on 18/04/2022.
//

import UIKit

extension UIImage {
    /// Draws the image inside a container to fit the given ratio.
    func interpolated(to ratio: CGFloat) -> UIImage {
        let currentRatio = size.width / size.height
        guard ratio != currentRatio else { return self }
        
        let maxDimension = max(size.width, size.height)
        let newRect = CGRect(x: 0, y: 0, width: maxDimension, height: maxDimension)
        let imageOrigin = CGPoint(x: (newRect.width - size.width) / 2, y: (newRect.height - size.height) / 2)

        let renderer = UIGraphicsImageRenderer(bounds: newRect)
        let interpolatedImage = renderer.image { _ in
            self.draw(at: imageOrigin)
        }
        
        return interpolatedImage
    }
}

extension UIImage.Orientation {
    var exifOrientation: Int32 {
        switch self {
            case .up: return 1
            case .down: return 3
            case .left: return 8
            case .right: return 6
            case .upMirrored: return 2
            case .downMirrored: return 4
            case .leftMirrored: return 5
            case .rightMirrored: return 7
            @unknown default: return 1
        }
    }
}

extension UIImage {
  /**
    Resizes the image.

    - Parameter scale: If this is 1, `newSize` is the size in pixels.
  */
  @nonobjc public func resized(to newSize: CGSize, scale: CGFloat = 1) -> UIImage {
    let format = UIGraphicsImageRendererFormat.default()
    format.scale = scale
    let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
    let originalImage = renderer.image { _ in
      draw(in: CGRect(origin: .zero, size: newSize))
    }
    return originalImage
  }

  /**
    Rotates the image around its center.

    - Parameter degrees: Rotation angle in degrees.
    - Parameter keepSize: If true, the new image has the size of the original
      image, so portions may be cropped off. If false, the new image expands
      to fit all the pixels.
  */
  @nonobjc public func rotated(by degrees: CGFloat, keepSize: Bool = true) -> UIImage {
    let radians = degrees * .pi / 180
    let newRect = CGRect(origin: .zero, size: size).applying(CGAffineTransform(rotationAngle: radians))

    // Trim off the extremely small float value to prevent Core Graphics from rounding it up.
    var newSize = keepSize ? size : newRect.size
    newSize.width = floor(newSize.width)
    newSize.height = floor(newSize.height)

    return UIGraphicsImageRenderer(size: newSize).image { rendererContext in
      let context = rendererContext.cgContext
      context.setFillColor(UIColor.black.cgColor)
      context.fill(CGRect(origin: .zero, size: newSize))
      context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
      context.rotate(by: radians)
      let origin = CGPoint(x: -size.width / 2, y: -size.height / 2)
      draw(in: CGRect(origin: origin, size: size))
    }
  }
}
