//
//  ImageProcessingContract.swift
//  AnylineUIKit
//
//  Created by Mac on 12/4/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation

protocol ImageProcessingViewPresenterProtocol: AnyObject {
    func attachView(_ view: ImageProcessingViewProtocol)
    func setImageBrightnesAndContrast(valueBrightnes: Float, valueContrast: Float)
    func setFiltredImageVersion(image: UIImage?)
    func setGrayFilter()
    func setBWFilter()
    func setColorFilter()
    func returnToDefault()
    func setAutoContrast()
    func setAutoBrightness()
    func resultPage()
    func applyForAllImages(brigtness: Float, contrast: Float)
    
    func getColorProcessingOfImage() -> DocumentScanViewEnums.ImageProccessingMode
    
    func getEnableBrightness() -> Bool
    func getEnableContrast() -> Bool
    
    func setDisableBrightness()
    func setDisableContrast()
    
    func setColorProcessingOfImage(option: DocumentScanViewEnums.ImageProccessingMode)
    
}

protocol ImageProcessingViewProtocol: AnyObject, Alertable {
    func setImage(image: UIImage?)
    func setControls(isAutoBrightnes: Bool, isAutoContrast: Bool, typeOfColor: DocumentScanViewEnums.ImageProccessingMode)
}

protocol ImageProcessingPresenterResultProtocol: AnyObject {
    func imageProcessingPresenterDidChangePages(pages: [ResultPage])
}
