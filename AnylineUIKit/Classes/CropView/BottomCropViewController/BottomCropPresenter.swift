//
//  BottomCropPresenter.swift
//  AnylineUIKit
//
//  Created by Mac on 11/20/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation
import Anyline

class BottomCropPresenter {
    
    var documentConfig: DocumentScanViewConfig
    private weak var view: BottomCropViewProtocol?
    weak var resultDelegate: BottomCropPresenterResultProtocol? = nil
    
    init(documentConfig: DocumentScanViewConfig) {
        self.documentConfig = documentConfig
    }
}

extension BottomCropPresenter: BottomCropViewPresenterProtocol {
    func onCancelButton() {
        resultDelegate?.onCancelButton()
    }
    
    func onOkButton() {
        resultDelegate?.onOkButton()
    }
    
    func getTintControls() -> UIColor {
        documentConfig.getTintControls()
    }
    
    func getBackgroundBottomBar() -> UIColor {
        documentConfig.getBackgroundBottomBar()
    }
    
    func attachView(_ view: BottomCropViewProtocol) {
        self.view = view
    }
}

extension BottomCropPresenter: CropPresenterResultProtocol {
    func scanPresenterDidChangeOk(isEnable: Bool) {
        view?.setupOkButton(isEnabled: isEnable)
    }
}
