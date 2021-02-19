//
//  RectangleFeature.swift
//  AnylineUIKit
//
//  Created by Valentin Rep on 22.12.2020..
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation
import Anyline

struct RectangleFeature {
    var topLeft: CGPoint
    var topRight: CGPoint
    var bottomLeft: CGPoint
    var bottomRight: CGPoint
    
    mutating func rotateBy90(_ imageSizeAfterRotate: CGSize) {
        let nTopLeft = CGPoint(x: imageSizeAfterRotate.width - self.bottomLeft.y, y: self.bottomLeft.x)
        let nTopRight = CGPoint(x: imageSizeAfterRotate.width - self.topLeft.y, y: self.topLeft.x)
        let nBottomRight = CGPoint(x: imageSizeAfterRotate.width - self.topRight.y, y: self.topRight.x)
        let nBottomLeft = CGPoint(x: imageSizeAfterRotate.width - self.bottomRight.y, y: self.bottomRight.x)
        
        self.topLeft = nTopLeft
        self.topRight = nTopRight
        self.bottomRight = nBottomRight
        self.bottomLeft = nBottomLeft
    }
    
    mutating func rotate(byNegative90 imageSizeAfterRotate: CGSize) {
        let nTopLeft = CGPoint(x: imageSizeAfterRotate.width - self.bottomLeft.y, y: self.bottomLeft.x)
        let nTopRight = CGPoint(x: imageSizeAfterRotate.width - self.topLeft.y, y: self.topLeft.x)
        let nBottomRight = CGPoint(x: imageSizeAfterRotate.width - self.topRight.y, y: self.topRight.x)
        let nBottomLeft = CGPoint(x: imageSizeAfterRotate.width - self.bottomRight.y, y: self.bottomRight.x)
        
        self.topLeft = nBottomRight
        self.topRight = nBottomLeft
        self.bottomRight = nTopLeft
        self.bottomLeft = nTopRight
    }
}
