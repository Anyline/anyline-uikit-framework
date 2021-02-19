//
//  ReducePictureSize.swift
//  AnylineUIKit
//
//  Created by Mac on 10/28/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation

struct ReducePictureSize: Codable {
    let allowChangeCustomSize: Bool?
    let option: String?
    let maxSizeSmall: Int?
    let maxSizeMedium: Int?
    let maxSizeLarge: Int?
    let maxSizeCustom: Int?
}
