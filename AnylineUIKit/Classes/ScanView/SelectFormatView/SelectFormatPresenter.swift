//
//  SelectFormatPresenter.swift
//  AnylineUIKit
//
//  Created by Mac on 11/2/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation

class SelectFormatPresenter {
    
    var documentConfig: DocumentScanViewConfig
    private weak var view: SelectFormatViewProtocol?
    weak var resultDelegate: SelectFormatPresenterResultProtocol? = nil
    
    init(documentConfig: DocumentScanViewConfig) {
        self.documentConfig = documentConfig
    }
}

extension SelectFormatPresenter: SelectFormatViewPresenterProtocol {
    func setCustomRatioValueShortAndLongSide(shortSide: String, longSide: String) {
        if shortSide != "" || shortSide != "0" || longSide != "" || longSide != "0" {
            if var shortSideValue = Int(shortSide), var longSideValue = Int(longSide) {
                if shortSideValue > longSideValue {
                    let tmp = shortSideValue
                    shortSideValue = longSideValue
                    longSideValue = tmp
                }
                documentConfig.setCustomRatioValueShortSide(value: shortSideValue)
                documentConfig.setCustomRatioValueLongSide(value: longSideValue)
            }
        }
    }
    
    func okAction() {
        resultDelegate?.selectFormatPresenterDidChangeFormat()
    }
    
    func attachView(_ view: SelectFormatViewProtocol) {
        self.view = view
    }
    
    func getCustomRatioValueLongSide() -> Int {
        return documentConfig.getCustomRatioValueLongSide()
    }
    
    func getCustomRatioValueShortSide() -> Int {
        return documentConfig.getCustomRatioValueShortSide()
    }
    
    func getScanFormat(scanRatio: DocumentScanViewEnums.ScanRatio) -> Bool {
        return documentConfig.getScanFormat(scanRatio: scanRatio)
    }
    
    func setScanFormat(scanRatio: DocumentScanViewEnums.ScanRatio, scanFormat: Bool) {
        documentConfig.setScanFormat(scanRatio: scanRatio, scanFormat: scanFormat)
    }
    
    func setSelectScanFormat(scanFormat: DocumentScanViewEnums.SelectScanFormat) {
        documentConfig.setSelectScanFormat(selectScanFormat: scanFormat)
    }
    
    func getSelectScanFormat() -> DocumentScanViewEnums.SelectScanFormat {
        return documentConfig.getSelectScanFormat()
    }
}
