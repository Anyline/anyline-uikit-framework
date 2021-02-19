//
//  ScanPresenter.swift
//  AnylineUIKit
//
//  Created by Mac on 11/2/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation
import Anyline

class ScanPresenter {
    var documentConfig: DocumentScanViewConfig
    private weak var view: ScanViewProtocol?
    
    // Result delegate for notify about changes in Scan Presenter (communicate with other presenters)
    weak var resultDelegate: ScanPresenterResultProtocol? = nil
    
    // Init with DocumentScanViewConfig
    init(documentConfig: DocumentScanViewConfig) {
        self.documentConfig = documentConfig
    }
}

extension ScanPresenter: ScanViewPresenterProtocol {
    // Getting current size from documentConfig
    func getSize() -> CGFloat? {
        let option = documentConfig.getReducePictureSizeOption()
        switch option {
        case .noReduceSize:
            return nil
        case .small:
            return CGFloat(documentConfig.getReducePictureSizeMaxSizeSmall())
        case .medium:
            return CGFloat(documentConfig.getReducePictureSizeMaxSizeMedium())
        case .large:
            return CGFloat(documentConfig.getReducePictureSizeMaxSizeLarge())
        case .custom:
            return CGFloat(documentConfig.getReducePictureSizeMaxSizeCustom())
        }
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
    
    // Getting Text Hint color from documentConfig
    func getTextHint() -> UIColor {
        documentConfig.getTextHint()
    }
    
    // Getting Background Hint color from documentConfig
    func getBackgroundHint() -> UIColor {
        documentConfig.getBackgroundHint()
    }
    
    // Update ok button when new page was scaned
    func updateOkButton(count: Int) {
        resultDelegate?.scanPresenterDidChangeOk(count: count)
    }
    
    // Getting Scan Mode from documentConfig
    func getScanMode() -> DocumentScanViewEnums.ScanMode {
        return documentConfig.getScanMode()
    }
    
    // Update Tolerance and Ratios on view
    func updateToleranceAndRatios() {
        view?.updateRatioAndTolerance()
    }

    // Getting Ratios from documentConfig and prepare for scan view
    func getRatios() -> [NSNumber] {
        var ratios: [NSNumber] = []
        let selectFormat = documentConfig.getSelectScanFormat()
        
        var dShort = Double(documentConfig.getCustomRatioValueShortSide())
        var dLong = Double(documentConfig.getCustomRatioValueLongSide())
        
        if dShort > dLong {
            let d = dLong
            dLong = dShort
            dShort = d
        }
        
        var customRatioPortrait = 1.0
        if dLong != 0 {
            customRatioPortrait = dShort / dLong
        }
        
        switch selectFormat {
        case .all:
            ratios.append(NSNumber(value: getRatioRange()))
        case .predefined:
            if documentConfig.getScanFormat(scanRatio: .a4) {
                ratios.append(NSNumber(value: Double(ALDocumentRatioDINAXPortrait)))
            }
            if documentConfig.getScanFormat(scanRatio: .businessCard) {
                ratios.append(NSNumber(value: Double(ALDocumentRatioBusinessCardPortrait)))
            }
            if documentConfig.getScanFormat(scanRatio: .complimentSlip) {
                ratios.append(NSNumber(value: Double(ALDocumentRatioCompimentsSlipPortrait)))
            }
            if documentConfig.getScanFormat(scanRatio: .letter) {
                ratios.append(NSNumber(value: Double(ALDocumentRatioLetterPortrait)))
            }
            if documentConfig.getScanFormat(scanRatio: .customRatio) {
                ratios.append(NSNumber(value: Double(customRatioPortrait)))
            }
        }
        
        if (ratios.count == 0) {
            // if no ratio specified: have a landscape ratio from appx. 1:1 to 1:6
            ratios.append(NSNumber(0.33))   // range including tolerance of 0.15: 0,16 - 0,46
            ratios.append(NSNumber(0.60))   // range including tolerance of 0.15: 0,45 - 0,75
            ratios.append(NSNumber(0.88))   // range including tolerance of 0.15: 0,73 - 1,03
        }
        return ratios
    }
    
    // Getting Ratios Tolerance from documentConfig
    func getRatiosTolerance() -> NSNumber {
        let selectFormat = documentConfig.getSelectScanFormat()
        switch selectFormat {
        case .all:
            return NSNumber(value: getRatioRange())
        case .predefined:
            return NSNumber(value: getDocumentRatiosTolerance())
        }
    }
    
    // Getting Flash Status from documentConfig
    func getFlashStatus() -> ALFlashStatus {
        return documentConfig.getFlashMode()
    }
    
    // Prepare Presenter for bottom sheet of scan view
    func createBottomSheet() -> BottomSheetPresenter {
        let presenter = BottomSheetPresenter(documentConfig: documentConfig)
        presenter.resultDelegate = self
        self.resultDelegate = presenter
        return presenter
    }
    
    // Prepare Crop presenter for bottom sheet of scan view
    func createCropPresenter() -> CropPresenter {
        let presenter = CropPresenter(documentConfig: documentConfig)
        return presenter
    }
    
    func attachView(_ view: ScanViewProtocol) {
        self.view = view
    }
}

private extension ScanPresenter {
    func getRatioRange() -> Double {
        let minRatio = Double(documentConfig.getAllFormatsMinRatioWidth()) / Double(documentConfig.getAllFormatsMinRatioHeight())
        let maxRatio = Double(documentConfig.getAllFormatsMaxRatioWidth()) / Double(documentConfig.getAllFormatsMaxRatioHeight())

        return (maxRatio + minRatio) / 2
    }

    func getRatioRangeTolerance() -> Double {
        let minRatio = Double(documentConfig.getAllFormatsMinRatioWidth()) / Double(documentConfig.getAllFormatsMinRatioHeight())
        let maxRatio = Double(documentConfig.getAllFormatsMaxRatioWidth()) / Double(documentConfig.getAllFormatsMaxRatioHeight())

        return ((maxRatio - minRatio) / 2) + ((maxRatio - minRatio) / 2) * 0.05   // add 5 % to tolerance
    }
    
    func getDocumentRatiosTolerance() -> Double {
        return documentConfig.getFormatTolerance()
    }
}

extension ScanPresenter: BottomSheetPresenterResultProtocol {
    func bottomSheetPresenterDidCallOk() {
        view?.onOkButton()
    }
    
    // When we change scan mode from bottom sheet make ok button counter zero and reset scaned page
    func bottomSheetPresenterDidChangeScanMode() {
        view?.resetScanedPage()
        updateOkButton(count: 0)
    }

    // When we click on cancel button on bottom sheet we cancel scan view
    func bottomSheetPresenterDidCallCancel() {
        view?.onCancelButton()
    }
    
    // When we click on manual button on bottom sheet we call method to handle manual button action
    func bottomSheetPresenterDidCallManual() {
        view?.onManualButton()
    }
    
    // When we change state on bottom sheet we start/stop scanning
    func bottomSheetPresenterDidChangeExpandedState(isExpanded: Bool) {
        if isExpanded {
            view?.stopScanning()
            view?.showPaused(show: true)
        } else {
            view?.startScanning()
            view?.showPaused(show: false)
        }
    }
    
    // When we change ratios on bottom sheet we update it in scan view
    func bottomSheetPresenterDidChangeScanFormat() {
        updateToleranceAndRatios()
    }
    
    // When we flash mode on bottom sheet we update it in scan view
    func bottomSheetPresenterDidChangeFlashMode(status: ALFlashStatus) {
        view?.setFlashStatus(status: status)
    }
}
