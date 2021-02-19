//
//  SelectSizeContract.swift
//  AnylineUIKit
//
//  Created by Mac on 11/2/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation

protocol SelectSizeViewPresenterProtocol: AnyObject {
    func attachView(_ view: SelectSizeViewProtocol)
    func getReducePictureSizeOption() -> DocumentScanViewEnums.ReduceSizeOption
    func getReducePictureSizeMaxSizeCustom() -> Int
    func setReducePictureSizeOption(option: DocumentScanViewEnums.ReduceSizeOption)
    func setReducePictureSizeMaxSizeCustom(size: Int)
    func okButtonAction()
}

protocol SelectSizeViewProtocol: AnyObject {
}

protocol SelectSizePresenterResultProtocol: AnyObject {
    func selectSizePresenterDidChangeSize()
}
