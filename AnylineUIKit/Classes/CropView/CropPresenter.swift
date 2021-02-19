//
//  CropPresenter.swift
//  AnylineUIKit
//
//  Created by Mac on 11/20/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation
import Anyline

class CropPresenter {
    var documentConfig: DocumentScanViewConfig
    private weak var view: CropViewProtocol?
    weak var resultDelegate: CropPresenterResultProtocol? = nil
    
    init(documentConfig: DocumentScanViewConfig) {
        self.documentConfig = documentConfig
    }
}

extension CropPresenter: CropViewPresenterProtocol {
    
    func setPostProcessing(image: UIImage) -> UIImage {
        var newImage: UIImage = image
        
        if let option = self.getColorProcessing() {
            switch option {
            case .color:
                break
            case .blackAndWhite:
                newImage = setBWFilter(image: image)
            case .gray:
                newImage = setGrayFilter(image: image)
            }
        }
        
        if let isBrightness = self.getAutoBrightnessEnabling() {
            if isBrightness {
                newImage = self.setAutoBrightness(image: newImage)
            }
        }
        if let isContrast = self.getAutoContrastEnabling() {
            if isContrast {
                newImage = self.setAutoContrast(image: newImage)
            }
        }
        if let isWB = self.getAutoWhiteBalanceEnabling() {
            if isWB {
                newImage = newImage.applyFilter(.grayscale)
            }
        }
        return newImage
    }
    
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

    func updateOk(isEnabled: Bool) {
        resultDelegate?.scanPresenterDidChangeOk(isEnable: isEnabled)
    }
    
    func attachView(_ view: CropViewProtocol) {
        self.view = view
    }
    
    func createBottomSheet() -> BottomCropPresenter {
        let presenter = BottomCropPresenter(documentConfig: documentConfig)
        presenter.resultDelegate = self
        self.resultDelegate = presenter
        return presenter
    }
}

private extension CropPresenter {
    func setAutoContrast(image: UIImage) -> UIImage {

        let autoContrastImage = OpenCVWrapper.autoWBOpenCV(image)
        guard let imageNew = autoContrastImage else {
            return image
        }
        return imageNew
    }
    
    func setAutoBrightness(image: UIImage) -> UIImage {
        let autoContrastImage = OpenCVWrapper.processImage(withOpenCV: image)
   
        guard let imageNew = autoContrastImage else {
            return image
        }
        return imageNew
    }
    
    func setGrayFilter(image: UIImage) -> UIImage {
        let autoContrastImage = OpenCVWrapper.toGray(image)
   
        guard let imageNew = autoContrastImage else {
            return image
        }
        return imageNew
    }
    
    func setBWFilter(image: UIImage) -> UIImage {
        let autoContrastImage = OpenCVWrapper.toBlackAndWhite(image)
   
        guard let imageNew = autoContrastImage else {
            return image
        }
        return imageNew
    }
}

extension CropPresenter: BottomCropPresenterResultProtocol {
    func onCancelButton() {
        view?.cancel()
    }
    func onOkButton() {
        view?.completeCroppingAction()
    }
}

