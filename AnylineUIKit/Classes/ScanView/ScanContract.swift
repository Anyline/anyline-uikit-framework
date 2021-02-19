//
//  ScanContract.swift
//  AnylineUIKit
//
//  Created by Mac on 11/2/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation
import Anyline

// MARK: - Define methods of ScanViewPresenterProtocol
protocol ScanViewPresenterProtocol: AnyObject {
    func attachView(_ view: ScanViewProtocol)

    func createBottomSheet() -> BottomSheetPresenter
    func createCropPresenter() -> CropPresenter

    func getFlashStatus() -> ALFlashStatus
    func getRatios() -> [NSNumber]
    func getRatiosTolerance() -> NSNumber
    func getScanMode() -> DocumentScanViewEnums.ScanMode
    func getTextHint() -> UIColor
    func getBackgroundHint() -> UIColor
    func getSize() -> CGFloat?
    
    func getColorProcessing() -> DocumentScanViewEnums.ImageProccessingMode?
    func getAutoWhiteBalanceEnabling() -> Bool?
    func getAutoContrastEnabling() -> Bool?
    func getAutoBrightnessEnabling() -> Bool?

    func updateToleranceAndRatios()
    func updateOkButton(count: Int)
}

// MARK: - Define methods of ScanViewProtocol
protocol ScanViewProtocol: AnyObject, Alertable {
    func setFlashStatus(status: ALFlashStatus)
    func showPaused(show: Bool)
    func updateRatioAndTolerance()
    func stopScanning()
    func startScanning()
    func onManualButton()
    func onOkButton()
    func onCancelButton()
    func resetScanedPage()
}

// MARK: - Define methods of delegate ScanPresenterResultProtocol
protocol ScanPresenterResultProtocol: AnyObject {
    func scanPresenterDidChangeOk(count: Int)
}

