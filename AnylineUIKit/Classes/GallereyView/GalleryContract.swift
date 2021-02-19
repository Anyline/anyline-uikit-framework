//
//  GalleryContract.swift
//  AnylineUIKit
//
//  Created by Mac on 11/26/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation

protocol GalleryViewPresenterProtocol: AnyObject {
    func attachView(_ view: GalleryViewProtocol)
    func createBottomGalleryPresenter() -> BottomGalleryPresenter
    func createCropViewPresenter() -> CropPresenter
    func createRearangeImagesViewPresenter() -> RearrangeImagesPresenter
    func createScanView() -> ScanView
    func getTintColor() -> UIColor
    func getTintColorDisabled() -> UIColor
    
    func getColorProcessing() -> DocumentScanViewEnums.ImageProccessingMode?
    func getAutoWhiteBalanceEnabling() -> Bool?
    func getAutoContrastEnabling() -> Bool?
    func getAutoBrightnessEnabling() -> Bool?
}

protocol GalleryViewProtocol: AnyObject, Alertable {
    func turnLeft()
    func turnRight()
    func deletePage()
    func showCropView()
    func showRearrangeView()
    func showNewScan()
    func showImportImage()
    func showImageProcessing(documentConfig: DocumentScanViewConfig, galleryPresenter: GalleryPresenter)
    func updatePages(pages: [ResultPage])
}

protocol GalleryPresenterResultProtocol: AnyObject {
}
