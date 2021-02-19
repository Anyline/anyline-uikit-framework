//
//  SelectSizePresenter.swift
//  AnylineUIKit
//
//  Created by Mac on 11/2/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation

class SelectSizePresenter {
    
    var documentConfig: DocumentScanViewConfig
    private weak var view: SelectSizeViewProtocol?
    weak var resultDelegate: SelectSizePresenterResultProtocol? = nil

    init(documentConfig: DocumentScanViewConfig) {
        self.documentConfig = documentConfig
    }
}

extension SelectSizePresenter: SelectSizeViewPresenterProtocol {
    func okButtonAction() {
        resultDelegate?.selectSizePresenterDidChangeSize()
    }
    
    func attachView(_ view: SelectSizeViewProtocol) {
        self.view = view
    }
    
    func getReducePictureSizeMaxSizeCustom() -> Int {
        return documentConfig.getReducePictureSizeMaxSizeCustom()
    }
    
    func getReducePictureSizeOption() -> DocumentScanViewEnums.ReduceSizeOption {
        return documentConfig.getReducePictureSizeOption()
    }
    
    func setReducePictureSizeOption(option: DocumentScanViewEnums.ReduceSizeOption) {
        documentConfig.setReducePictureSizeOption(option: option)
    }
    
    func setReducePictureSizeMaxSizeCustom(size: Int) {
        documentConfig.setReducePictureSizeMaxSizeCustom(size: size)
    }
}
