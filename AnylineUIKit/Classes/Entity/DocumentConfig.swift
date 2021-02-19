//
//  DocumentConfig.swift
//  AnylineUIKit
//
//  Created by Mac on 10/28/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation

struct DocumentConfig: Codable {
    let scanMode: String?
    let enablePostProcessing: Bool?
    let showCancelOnCropView: Bool?
    let reducePictureSize: ReducePictureSize?
    let scanFormat: ScanFormat?
    let bottomBar: BottomBar?
    let bottomBarExtension: BottomBarExtension?
    let bottomGalleryBar: BottomBar?
    let bottomGalleryBarExtension: BottomBarExtension?
    let colors: Colors?
    let imageProcessing: ImageProcessing?
}
