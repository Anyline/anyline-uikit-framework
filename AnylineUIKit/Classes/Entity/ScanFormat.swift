//
//  ScanFormat.swift
//  AnylineUIKit
//
//  Created by Mac on 10/28/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation

struct ScanFormat: Codable {
    let selectFormats: String?
    let formatTolerance: String?
    let a4: Bool?
    let complimentSlip: Bool?
    let businessCard: Bool?
    let letter: Bool?
    let customRatio: Bool?
    let customRatioValueShortSide: Int?
    let customRatioValueLongSide: Int?
    let allformatsminratio: Ratio?
    let allformatsmaxratio: Ratio?
}
