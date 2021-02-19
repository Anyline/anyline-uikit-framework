//
//  RearrangeImagesContract.swift
//  AnylineUIKit
//
//  Created by Mac on 12/1/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation

protocol RearrangeImagesViewPresenterProtocol: AnyObject {
    func attachView(_ view: RearrangeImagesViewProtocol)
    func getTintControls() -> UIColor
    func getBackgroundBottomBar() -> UIColor
    func saveOrderPages(pages: [ResultPage])
}

protocol RearrangeImagesViewProtocol: AnyObject, Alertable {
}

protocol RearrangeImagesPresenterResultProtocol: AnyObject {
    func rearrangeImagesPresenterDidChangeOrder(pages: [ResultPage])
}
