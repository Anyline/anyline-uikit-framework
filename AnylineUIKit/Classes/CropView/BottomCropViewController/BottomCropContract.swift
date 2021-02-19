//
//  BottomCropContract.swift
//  AnylineUIKit
//
//  Created by Mac on 11/20/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation
import Anyline

protocol BottomCropViewPresenterProtocol: AnyObject {
    func attachView(_ view: BottomCropViewProtocol)
    func getTintControls() -> UIColor
    func getBackgroundBottomBar() -> UIColor
    func onOkButton()
    func onCancelButton()
}

protocol BottomCropViewProtocol: AnyObject {
    func setupOkButton(isEnabled: Bool)
}

protocol BottomCropPresenterResultProtocol: AnyObject {
    func onOkButton()
    func onCancelButton()
}
