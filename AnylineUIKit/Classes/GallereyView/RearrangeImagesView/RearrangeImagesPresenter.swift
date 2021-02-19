//
//  RearrangeImagesPresenter.swift
//  AnylineUIKit
//
//  Created by Mac on 12/1/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

class RearrangeImagesPresenter {
    var documentConfig: DocumentScanViewConfig
    private weak var view: RearrangeImagesViewProtocol?
    
    weak var resultDelegate: RearrangeImagesPresenterResultProtocol? = nil
    
    
    init(documentConfig: DocumentScanViewConfig) {
        self.documentConfig = documentConfig
    }
}

extension RearrangeImagesPresenter: RearrangeImagesViewPresenterProtocol {
    func saveOrderPages(pages: [ResultPage]) {
        resultDelegate?.rearrangeImagesPresenterDidChangeOrder(pages: pages)
    }
    
    func getTintControls() -> UIColor {
        documentConfig.getTintControls()
    }
    
    func getBackgroundBottomBar() -> UIColor {
        documentConfig.getBackgroundBottomBar()
    }
    
    func attachView(_ view: RearrangeImagesViewProtocol) {
        self.view = view
    }
}

private extension RearrangeImagesPresenter {
}
