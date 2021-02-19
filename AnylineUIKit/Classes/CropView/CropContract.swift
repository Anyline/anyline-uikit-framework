//
//  CropContract.swift
//  AnylineUIKit
//
//  Created by Mac on 11/20/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation

protocol CropViewPresenterProtocol: AnyObject {
    func attachView(_ view: CropViewProtocol)
    func createBottomSheet() -> BottomCropPresenter
    func updateOk(isEnabled: Bool)
    
    func getColorProcessing() -> DocumentScanViewEnums.ImageProccessingMode?
    func getAutoWhiteBalanceEnabling() -> Bool?
    func getAutoContrastEnabling() -> Bool?
    func getAutoBrightnessEnabling() -> Bool?
    
    func setPostProcessing(image: UIImage) -> UIImage
}

protocol CropViewProtocol: AnyObject, Alertable {
    func completeCroppingAction()
    func cancel()
}

protocol CropPresenterResultProtocol: AnyObject {
    func scanPresenterDidChangeOk(isEnable: Bool)
}
