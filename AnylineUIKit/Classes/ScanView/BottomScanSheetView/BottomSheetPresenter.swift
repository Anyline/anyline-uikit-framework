//
//  BottomSheetPresenter.swift
//  AnylineUIKit
//
//  Created by Mac on 11/2/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation
import Anyline

class BottomSheetPresenter {
    
    var documentConfig: DocumentScanViewConfig
    private weak var view: BottomScanSheetViewProtocol?
    
    // Result delegate for notify about changes in Bottom Sheet presenter (communicate with other presenters)
    weak var resultDelegate: BottomSheetPresenterResultProtocol? = nil
    
    init(documentConfig: DocumentScanViewConfig) {
        self.documentConfig = documentConfig
    }
}

extension BottomSheetPresenter: BottomScanSheetViewPresenterProtocol {
    
    func getScanBottomBarControls() -> [DocumentScanViewEnums.BottomBarControl] {
        return documentConfig.getScanBottomBar()
    }
    
    func getScanBottomBarExtensionControls() -> [DocumentScanViewEnums.BottomBarControl] {
        return documentConfig.getScanExtensionBottomBar()
    }
    // Notyfy about click on ok button
    func onOkButton() {
        resultDelegate?.bottomSheetPresenterDidCallOk()
    }

    // Getting Background Bottom Bar color from documentConfig
    func getBackgroundBottomBar() -> UIColor {
        documentConfig.getBackgroundBottomBar()
    }
    
    // Getting Background Messager color from documentConfig
    func getBackgroundMessager() -> UIColor {
        documentConfig.getBackgroundMessager()
    }
    
    // Getting Divider color from documentConfig
    func getDivider() -> UIColor {
        documentConfig.getDivider()
    }
    
    // Getting Text Bottom Bar color from documentConfig
    func getTextBottomBar() -> UIColor {
        documentConfig.getTextBottomBar()
    }
    
    // Getting Text Message color from documentConfig
    func getTextMessage() -> UIColor {
        documentConfig.getTextMessage()
    }
    
    // Getting Tint Controls color from documentConfig
    func getTintControls() -> UIColor {
        documentConfig.getTintControls()
    }
    
    // Getting Tint Controls Disabled color from documentConfig
    func getTintControlsDisabled() -> UIColor {
        documentConfig.getTintControlsDisabled()
    }
    
    // Getting Tint Manual Picture Button color from documentConfig
    func getTintManualPictureButton() -> UIColor {
        documentConfig.getTintManualPictureButton()
    }
    
    // Notyfy about click on cancel button
    func onCancelButton() {
        resultDelegate?.bottomSheetPresenterDidCallCancel()
    }
    
    // Update counter of ok button
    func updateOkButton(count: Int) {
        view?.setOkButton(count: count)
    }
    
    // Notyfy about click on manual button
    func onManualButton() {
        resultDelegate?.bottomSheetPresenterDidCallManual()
    }
    
    // Notyfy about change of bottom sheet state
    func setExpandedState(state: Bool) {
        resultDelegate?.bottomSheetPresenterDidChangeExpandedState(isExpanded: state)
    }
    
    // Getting flash mode from document config
    func getFlashMode() -> ALFlashStatus {
        documentConfig.getFlashMode()
    }
    
    // Notyfy about change flash mode on bottom sheet
    func onFlash(status: ALFlashStatus) {
        resultDelegate?.bottomSheetPresenterDidChangeFlashMode(status: status)
    }
    
    // Prepare Select Size Presenter
    func createSelectSizePresenter() -> SelectSizePresenter {
        let presenter = SelectSizePresenter(documentConfig: documentConfig)
        presenter.resultDelegate = self
        return presenter
    }
    
    // Prepare Select Format Presenter
    func createSelectFormatPresenter() -> SelectFormatPresenter {
        let presenter = SelectFormatPresenter(documentConfig: documentConfig)
        presenter.resultDelegate = self
        return presenter
    }

    // Prepare scan size string
    func getScanSizeString() -> String {
        let reduseSizeOption = documentConfig.getReducePictureSizeOption()
        switch reduseSizeOption {
        case .small:
            return "Small (max 300 pixeles)"
        case .medium:
            return "Medium (max 600 pixels)"
        case .large:
            return "Large (max 1200 pixels)"
        case .custom:
            return "Custom"
        case .noReduceSize:
            return "No reduce size"
        }
    }
    
    // Prepare scan format string
    func getScanFormatString() -> String {
        var scanFormat = ""
        let scanFormatOption = documentConfig.getSelectScanFormat()
        switch scanFormatOption {
        case .all:
            return "All portrait formats"
        case .predefined:
            if documentConfig.getScanFormat(scanRatio: .a4) {
                scanFormat += "A4, "
            }
            if documentConfig.getScanFormat(scanRatio: .businessCard) {
                scanFormat += "Business Card, "
            }
            if documentConfig.getScanFormat(scanRatio: .complimentSlip) {
                scanFormat += "Compliment Slip, "
            }
            if documentConfig.getScanFormat(scanRatio: .letter) {
                scanFormat += "Letter, "
            }
            if documentConfig.getScanFormat(scanRatio: .customRatio) {
                scanFormat += "Custom, "
            }
            return scanFormat.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .punctuationCharacters)
        }
    }
    
    func attachView(_ view: BottomScanSheetViewProtocol) {
        self.view = view
    }
    
    // Setting new scan mode to documentConfig
    func setScanMode(scanMode: DocumentScanViewEnums.ScanMode) {
        documentConfig.setScanMode(scanMode: scanMode)
        resultDelegate?.bottomSheetPresenterDidChangeScanMode()
    }
    
    // Getting scan mode to documentConfig
    func getScanMode() -> DocumentScanViewEnums.ScanMode? {
        print("aaaa -> ", documentConfig, documentConfig.getScanMode())
        return documentConfig.getScanMode()
    }
}

extension BottomSheetPresenter: SelectSizePresenterResultProtocol {
    // Update view when select size view change value
    func selectSizePresenterDidChangeSize() {
        view?.updateView()
        view?.closeView()
    }
}

extension BottomSheetPresenter: SelectFormatPresenterResultProtocol {
    // Update view when select format view change value
    func selectFormatPresenterDidChangeFormat() {
        view?.updateView()
        resultDelegate?.bottomSheetPresenterDidChangeScanFormat()
        view?.closeView()
    }
}

extension BottomSheetPresenter: ScanPresenterResultProtocol {
    // Setup ok button counter when count of scaned page was changed
    func scanPresenterDidChangeOk(count: Int) {
        view?.setOkButton(count: count)
    }
}
