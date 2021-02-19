//
//  UIImageView+GeometryConversion.swift
//  AnylineUIKit
//
//  Created by Mac on 22.12.2020..
//  Copyright © 2020 Anyline. All rights reserved.
//

import UIKit

extension UIImageView {
    func convertPointFromImage(imagePoint: CGPoint) -> CGPoint {
        var viewPoint: CGPoint = imagePoint
        
        guard let image = image else {
            return viewPoint
        }

        let imageSize: CGSize = image.size
        let viewSize: CGSize = self.bounds.size

        let ratioX:CGFloat = viewSize.width / imageSize.width
        let ratioY:CGFloat = viewSize.height / imageSize.height

        let contentMode: UIView.ContentMode = self.contentMode

        switch (contentMode) {
        case .scaleToFill, .redraw:
            viewPoint.x *= ratioX
            viewPoint.y *= ratioY
            break

        case .scaleAspectFit, .scaleAspectFill:
            var scale:CGFloat

            if contentMode == .scaleAspectFit {
                scale = min(ratioX, ratioY)
            } else {
                scale = max(ratioX, ratioY)
            }

            viewPoint.x *= scale
            viewPoint.y *= scale

            viewPoint.x += (viewSize.width - imageSize.width  * scale) / 2.0
            viewPoint.y += (viewSize.height - imageSize.height * scale) / 2.0
            break

        case .center:
            viewPoint.x += viewSize.width / 2.0 - imageSize.width  / 2.0
            viewPoint.y += viewSize.height / 2.0 - imageSize.height / 2.0
            break

        case .top:
            viewPoint.x += viewSize.width / 2.0 - imageSize.width / 2.0
            break

        case .bottom:
            viewPoint.x += viewSize.width / 2.0 - imageSize.width / 2.0
            viewPoint.y += viewSize.height - imageSize.height
            break

        case .left:
            viewPoint.y += viewSize.height / 2.0 - imageSize.height / 2.0
            break

        case .right:
            viewPoint.x += viewSize.width - imageSize.width
            viewPoint.y += viewSize.height / 2.0 - imageSize.height / 2.0
            break

        case .topRight:
            viewPoint.x += viewSize.width - imageSize.width
            break

        case .bottomLeft:
            viewPoint.y += viewSize.height - imageSize.height
            break

        case .bottomRight:
            viewPoint.x += viewSize.width  - imageSize.width
            viewPoint.y += viewSize.height - imageSize.height
            break

        //case UIViewContentModeTopLeft:
        default:
            break

        }

        return viewPoint
    }

    func convertRectFromImage(imageRect:CGRect) -> CGRect {
        let imageTopLeft: CGPoint = imageRect.origin
        let imageBottomRight: CGPoint = CGPoint(
            x: imageRect.maxX,
            y: imageRect.maxY
        )

        let viewTopLeft: CGPoint = self.convertPointFromImage(imagePoint: imageTopLeft)
        let viewBottomRight: CGPoint = self.convertPointFromImage(imagePoint: imageBottomRight)
        let size = CGSize(
            width: abs(viewBottomRight.x - viewTopLeft.x),
            height: abs(viewBottomRight.y - viewTopLeft.y)
        )
        
        return CGRect(
            origin: viewTopLeft,
            size: size
        )
    }

        func convertPointFromView(viewPoint: CGPoint) -> CGPoint {
            var imagePoint: CGPoint = viewPoint
            
            guard let image = image else {
                return imagePoint
            }

            let imageSize: CGSize = image.size
            let viewSize: CGSize = self.bounds.size

            let ratioX: CGFloat = viewSize.width / imageSize.width
            let ratioY: CGFloat = viewSize.height / imageSize.height

            let contentMode: UIView.ContentMode = self.contentMode

            switch (contentMode) {
            case .scaleToFill, .redraw:
                imagePoint.x /= ratioX
                imagePoint.y /= ratioY
                break

            case .scaleAspectFit, .scaleAspectFill:
                var scale: CGFloat

                if contentMode == .scaleAspectFit {
                    scale = min(ratioX, ratioY)
                } else  {
                    scale = max(ratioX, ratioY)
                }

                // Remove the x or y margin added in FitMode
                imagePoint.x -= (viewSize.width  - imageSize.width  * scale) / 2.0
                imagePoint.y -= (viewSize.height - imageSize.height * scale) / 2.0

                imagePoint.x /= scale
                imagePoint.y /= scale
                break

            case .center:
                imagePoint.x -= (viewSize.width - imageSize.width)  / 2.0
                imagePoint.y -= (viewSize.height - imageSize.height) / 2.0
                break

            case .top:
                imagePoint.x -= (viewSize.width - imageSize.width)  / 2.0
                break

            case .bottom:
                imagePoint.x -= (viewSize.width - imageSize.width)  / 2.0
                imagePoint.y -= (viewSize.height - imageSize.height)
                break

            case .left:
                imagePoint.y -= (viewSize.height - imageSize.height) / 2.0
                break

            case .right:
                imagePoint.x -= (viewSize.width - imageSize.width)
                imagePoint.y -= (viewSize.height - imageSize.height) / 2.0
                break

            case .topRight:
                imagePoint.x -= (viewSize.width - imageSize.width)
                break

            case .bottomLeft:
                imagePoint.y -= (viewSize.height - imageSize.height)
                break

            case .bottomRight:
                imagePoint.x -= (viewSize.width - imageSize.width)
                imagePoint.y -= (viewSize.height - imageSize.height)
                break

            //case UIViewContentModeTopLeft:
            default:
                break

            }

            return imagePoint
        }

        func convertRectFromView(viewRect: CGRect) -> CGRect {
            let viewTopLeft: CGPoint = viewRect.origin
            let viewBottomRight: CGPoint = CGPoint(
                x: viewRect.maxX,
                y: viewRect.maxY
            )

            let imageTopLeft: CGPoint = self.convertPointFromView(viewPoint: viewTopLeft)
            let imageBottomRight: CGPoint = self.convertPointFromView(viewPoint: viewBottomRight)
            let size = CGSize(
                width: abs(imageBottomRight.x - imageTopLeft.x),
                height: abs(imageBottomRight.y - imageTopLeft.y)
            )
            
            return CGRect(origin: imageTopLeft, size: size)
        }
}
