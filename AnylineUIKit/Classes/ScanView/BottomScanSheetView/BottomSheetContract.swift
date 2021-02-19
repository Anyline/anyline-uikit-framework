//
//  BottomSheetContract.swift
//  AnylineUIKit
//
//  Created by Mac on 11/2/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation
import Anyline

// MARK: - Define methods of BottomScanSheetViewPresenterProtocol
protocol BottomScanSheetViewPresenterProtocol: AnyObject {
    func attachView(_ view: BottomScanSheetViewProtocol)

    func getScanMode() -> DocumentScanViewEnums.ScanMode?
    func getFlashMode() -> ALFlashStatus
    func getScanSizeString() -> String
    func getScanFormatString() -> String
    func getBackgroundBottomBar() -> UIColor
    func getBackgroundMessager() -> UIColor
    func getDivider() -> UIColor
    func getTextBottomBar() -> UIColor
    func getTextMessage() -> UIColor
    func getTintControls() -> UIColor
    func getTintControlsDisabled() -> UIColor
    func getTintManualPictureButton() -> UIColor

    func createSelectSizePresenter() -> SelectSizePresenter
    func createSelectFormatPresenter() -> SelectFormatPresenter

    func setExpandedState(state: Bool)
    func setScanMode(scanMode: DocumentScanViewEnums.ScanMode)
    func getScanBottomBarControls() -> [DocumentScanViewEnums.BottomBarControl]
    func getScanBottomBarExtensionControls() -> [DocumentScanViewEnums.BottomBarControl]

    func onFlash(status: ALFlashStatus)
    func onManualButton()
    func onCancelButton()
    func onOkButton()

    func updateOkButton(count: Int)
}

// MARK: - Define methods of BottomScanSheetViewProtocol
protocol BottomScanSheetViewProtocol: AnyObject {
    func updateView()
    func setOkButton(count: Int)
    func closeView()
}

// MARK: - Define methods of BottomSheetPresenterResultProtocol
protocol BottomSheetPresenterResultProtocol: AnyObject {
    func bottomSheetPresenterDidChangeFlashMode(status: ALFlashStatus)
    func bottomSheetPresenterDidChangeScanFormat()
    func bottomSheetPresenterDidChangeScanMode()
    func bottomSheetPresenterDidChangeExpandedState(isExpanded: Bool)
    func bottomSheetPresenterDidCallManual()
    func bottomSheetPresenterDidCallCancel()
    func bottomSheetPresenterDidCallOk()
}

