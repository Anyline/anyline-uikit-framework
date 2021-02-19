//
//  UIImage+Transformations.swift
//  AnylineUIKit
//
//  Created by Mac on 22.12.2020..
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation

extension UIImage {

    func correctingPerspective(with rectangleFeature: RectangleFeature) -> UIImage {
        guard let ciImage = CIImage(image: self) else { return self }
        
        // create input params
        let rectangleCoordinates: [String: CIVector] = [
            "inputTopLeft": CIVector(cgPoint: convertCornerCoordinatesToCoreImageCoordinateSpace(point: rectangleFeature.topLeft)),
            "inputTopRight": CIVector(cgPoint: convertCornerCoordinatesToCoreImageCoordinateSpace(point: rectangleFeature.topRight)),
            "inputBottomLeft": CIVector(cgPoint: convertCornerCoordinatesToCoreImageCoordinateSpace(point: rectangleFeature.bottomLeft)),
            "inputBottomRight": CIVector(cgPoint: convertCornerCoordinatesToCoreImageCoordinateSpace(point: rectangleFeature.bottomRight))
        ]

        // apply transformation
        let transformedImage: CIImage = ciImage.applyingFilter("CIPerspectiveCorrection", parameters:rectangleCoordinates)

        // create cgimage from the transformed image
        let context: CIContext = CIContext(options: nil)
        guard let cgImage: CGImage = context.createCGImage(transformedImage, from: transformedImage.extent) else {
            return self
        }

        return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
    }
    
    
    func rotate(clockwise: Bool) -> UIImage {
        var rotatedImage: UIImage?

        let rotateSize = CGSize(width: self.size.height, height: self.size.width)
        UIGraphicsBeginImageContextWithOptions(rotateSize, false, self.scale)

        guard let context = UIGraphicsGetCurrentContext() else {
            return self
        }

        if clockwise {
            context.rotate(by: CGFloat(Double.pi/2))
            context.translateBy(x: 0, y: -self.size.height)
        } else {
            context.rotate(by: CGFloat(-Double.pi/2))
            context.translateBy(x: -self.size.width, y: 0)
        }

        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return rotatedImage ?? self
    }
    
    func rotate(radians: Float) -> UIImage {
            var newSize = CGRect(origin: CGPoint.zero, size: self.size)
                .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
                .size
            // Trim off the extremely small float value to prevent core graphics from rounding it up
            newSize.width = floor(newSize.width)
            newSize.height = floor(newSize.height)

            UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
            let context = UIGraphicsGetCurrentContext()!

            // Move origin to middle
            context.translateBy(x: newSize.width/2, y: newSize.height/2)
            // Rotate around middle
            context.rotate(by: CGFloat(radians))
            // Draw the image at its center
            self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return newImage ?? self
        }

    func rotate(degrees: Float) -> UIImage {
        return rotate(radians: degreesToRadians(degrees: degrees))
    }

    func scaling(with scale: CGFloat) -> UIImage! {
        let newSize:CGSize = self.size.applying(CGAffineTransform(scaleX: scale, y: scale))

        UIGraphicsBeginImageContextWithOptions(newSize, true, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let scaledImage:UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return scaledImage
    }

    private func convertCornerCoordinatesToCoreImageCoordinateSpace(point: CGPoint) -> CGPoint {
        if self.imageOrientation == .up || self.imageOrientation == .down {
            return CGPoint(x: point.x, y: self.size.height - point.y)
        } else {
            return CGPoint(x: point.x, y: self.size.width - point.y)
        }
    }
    
    private func degreesToRadians(degrees: Float) -> Float {
        return degrees * Float(Double.pi) / 180
    }
}

