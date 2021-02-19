//
//  BottomGalleryPresenter.swift
//  AnylineUIKit
//
//  Created by Mac on 11/26/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation
import Anyline

class BottomGalleryPresenter {
    var documentConfig: DocumentScanViewConfig
    private weak var view: BottomGalleryViewProtocol?
    weak var resultDelegate: BottomGalleryPresenterResultProtocol? = nil
    
    init(documentConfig: DocumentScanViewConfig) {
        self.documentConfig = documentConfig
    }
}

extension BottomGalleryPresenter: BottomGalleryViewPresenterProtocol {
    func onProcessingImage() {
        resultDelegate?.bottomGalleryPresenterDidCallProcessingImage()
    }
    func onImportPicture() {
        resultDelegate?.bottomGalleryPresenterDidCallImportImage()
    }
    
    func onNewScan() {
        resultDelegate?.bottomGalleryPresenterDidCallNewScan()
    }
    
    
    // Getting Background Bottom Bar color from documentConfig
    func getBackgroundBottomBar() -> UIColor {
        documentConfig.getBackgroundBottomBar()
    }
    
    // Getting Divider color from documentConfig
    func getDivider() -> UIColor {
        documentConfig.getDivider()
    }
    
    // Getting Text Bottom Bar color from documentConfig
    func getTextBottomBar() -> UIColor {
        documentConfig.getTextBottomBar()
    }

    // Getting Tint Controls color from documentConfig
    func getTintControls() -> UIColor {
        documentConfig.getTintControls()
    }
    
    // Getting Tint Controls Disabled color from documentConfig
    func getTintControlsDisabled() -> UIColor {
        documentConfig.getTintControlsDisabled()
    }
    
    func getBottomGalleryBar() -> [DocumentScanViewEnums.BottomGalleryBarControl] {
        return documentConfig.getScanBottomGalleryBar()
    }
    
    func getBottomGalleryExtensionBar() -> [DocumentScanViewEnums.BottomGalleryBarControl] {
        return documentConfig.getScanExtensionBottomGalleryBar()
    }

    func onDelete() {
        resultDelegate?.bottomGalleryPresenterDidCallDelete()
    }
    func onRearrangeImages() {
        resultDelegate?.bottomGalleryPresenterDidCallRearrange()
    }
    
    func onCrop() {
        resultDelegate?.bottomGalleryPresenterDidCallCrop()
    }
    
    func turnLeft() {
        resultDelegate?.bottomGallereyPresenterDidRotateLeft()
    }
    
    func turnRight() {
        resultDelegate?.bottomGallereyPresenterDidRotateRight()
    }
    
    func attachView(_ view: BottomGalleryViewProtocol) {
        self.view = view
    }
}

private extension BottomGalleryPresenter {
}
