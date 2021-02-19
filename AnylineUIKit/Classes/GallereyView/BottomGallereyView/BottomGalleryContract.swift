//
//  BottomGalleryContract.swift
//  AnylineUIKit
//
//  Created by Mac on 11/26/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation

protocol BottomGalleryViewPresenterProtocol: AnyObject {
    func attachView(_ view: BottomGalleryViewProtocol)
    func turnLeft()
    func turnRight()
    func onRearrangeImages()
    func onProcessingImage()
    func onCrop()
    func onDelete()
    func onNewScan()
    func onImportPicture()

    func getBottomGalleryBar() -> [DocumentScanViewEnums.BottomGalleryBarControl]
    func getBottomGalleryExtensionBar() -> [DocumentScanViewEnums.BottomGalleryBarControl]
    func getDivider() -> UIColor
    func getTextBottomBar() -> UIColor
    func getTintControls() -> UIColor
    func getTintControlsDisabled() -> UIColor
    func getBackgroundBottomBar() -> UIColor
}

protocol BottomGalleryViewProtocol: AnyObject, Alertable {
}

protocol BottomGalleryPresenterResultProtocol: AnyObject {
    func bottomGallereyPresenterDidRotateLeft()
    func bottomGallereyPresenterDidRotateRight()
    func bottomGalleryPresenterDidCallCrop()
    func bottomGalleryPresenterDidCallRearrange()
    func bottomGalleryPresenterDidCallDelete()
    func bottomGalleryPresenterDidCallNewScan()
    func bottomGalleryPresenterDidCallImportImage()
    func bottomGalleryPresenterDidCallProcessingImage()
}
