//
//  SelectFormatContract.swift
//  AnylineUIKit
//
//  Created by Mac on 11/2/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation

protocol SelectFormatViewPresenterProtocol: AnyObject {
    func attachView(_ view: SelectFormatViewProtocol)
    func getSelectScanFormat() -> DocumentScanViewEnums.SelectScanFormat
    func setSelectScanFormat(scanFormat: DocumentScanViewEnums.SelectScanFormat)
    func getScanFormat(scanRatio: DocumentScanViewEnums.ScanRatio) -> Bool
    func setScanFormat(scanRatio: DocumentScanViewEnums.ScanRatio, scanFormat: Bool)
    func getCustomRatioValueShortSide() -> Int
    func getCustomRatioValueLongSide() -> Int
    func setCustomRatioValueShortAndLongSide(shortSide: String, longSide: String)
    func okAction()
}

protocol SelectFormatViewProtocol: AnyObject {
    func dismissSelectView()
}

protocol SelectFormatPresenterResultProtocol: AnyObject {
    func selectFormatPresenterDidChangeFormat()
}
