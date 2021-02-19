//
//  GalleryPresenter.swift
//  AnylineUIKit
//
//  Created by Mac on 11/26/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation
import Anyline

class GalleryPresenter {
    var documentConfig: DocumentScanViewConfig
    private weak var view: GalleryViewProtocol?
    weak var resultDelegate: GalleryPresenterResultProtocol? = nil
    
    init(documentConfig: DocumentScanViewConfig) {
        self.documentConfig = documentConfig
    }
}

extension GalleryPresenter: GalleryViewPresenterProtocol {
    func getTintColor() -> UIColor {
        return documentConfig.getTintControls()
    }
    
    func getTintColorDisabled() -> UIColor {
        return documentConfig.getTintControlsDisabled()
    }
    
    func createScanView() -> ScanView {
        let view = ScanView(documentConfig: documentConfig)
        return view
    }
    
    func createRearangeImagesViewPresenter() -> RearrangeImagesPresenter {
        let presenter = RearrangeImagesPresenter(documentConfig: documentConfig)
        presenter.resultDelegate = self
        return presenter
    }
    
    func createBottomGalleryPresenter() -> BottomGalleryPresenter {
        let presenter = BottomGalleryPresenter(documentConfig: documentConfig)
        presenter.resultDelegate = self
        return presenter
    }
    
    func createCropViewPresenter() -> CropPresenter {
        let presenter = CropPresenter(documentConfig: documentConfig)
        presenter.resultDelegate = self
        return presenter
    }
    
    func attachView(_ view: GalleryViewProtocol) {
        self.view = view
    }
}

private extension GalleryPresenter {
}

extension GalleryPresenter: BottomGalleryPresenterResultProtocol {
    
    // Getting color processing
    func getColorProcessing() -> DocumentScanViewEnums.ImageProccessingMode? {
        let option = documentConfig.getProcessingColorMode()
        return option
    }
    
    // Getting Auto White Balance processing
    func getAutoWhiteBalanceEnabling() -> Bool? {
        let option = documentConfig.getAutoWhiteBalance()
        return option
    }
    
    // Getting Auto Contrast processing
    func getAutoContrastEnabling() -> Bool? {
        let option = documentConfig.getAutoContrast()
        return option
    }
    
    // Getting Auto Brightness processing
    func getAutoBrightnessEnabling() -> Bool? {
        let option = documentConfig.getAutoBrightness()
        return option
    }
    
    func bottomGalleryPresenterDidCallProcessingImage() {
        view?.showImageProcessing(documentConfig: documentConfig, galleryPresenter: self)
    }

    func bottomGalleryPresenterDidCallImportImage() {
        view?.showImportImage()
    }
    
    func bottomGalleryPresenterDidCallNewScan() {
        view?.showNewScan()
    }
    
    func bottomGalleryPresenterDidCallDelete() {
        view?.deletePage()
    }

    func bottomGalleryPresenterDidCallRearrange() {
        view?.showRearrangeView()
    }
    
    func bottomGalleryPresenterDidCallCrop() {
        view?.showCropView()
    }
    
    func bottomGallereyPresenterDidRotateLeft() {
        view?.turnLeft()
    }
    
    func bottomGallereyPresenterDidRotateRight() {
        view?.turnRight()
    }
}

extension GalleryPresenter: RearrangeImagesPresenterResultProtocol {
    func rearrangeImagesPresenterDidChangeOrder(pages: [ResultPage]) {
        view?.updatePages(pages: pages)
    }
}

extension GalleryPresenter: CropPresenterResultProtocol {
    func scanPresenterDidChangeOk(isEnable: Bool) {
        
    }
}

extension GalleryPresenter: ImageProcessingPresenterResultProtocol {
    func imageProcessingPresenterDidChangePages(pages: [ResultPage]) {
        view?.updatePages(pages: pages)
    }
}
