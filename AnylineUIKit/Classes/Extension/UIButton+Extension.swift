//
//  UIButton+Extention.swift
//  AnylineUIKit
//
//  Created by Mac on 10/20/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func setupBaseBottomScanUIButton(imageName: String, selectedImageName: String?, tintColor: UIColor) {
        let bundle = Bundle(for: BottomScanSheetView.self)
        let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
        self.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        if let selectedImageName = selectedImageName {
            let selectedImage = UIImage(named: selectedImageName, in: bundle, compatibleWith: nil)
            self.setImage(selectedImage?.withRenderingMode(.alwaysTemplate), for: .selected)
        }
        self.tintColor = tintColor
        self.contentHorizontalAlignment = .fill
        self.contentVerticalAlignment = .fill
        self.imageView?.contentMode = .scaleAspectFit
        self.setTitle("", for: .normal)
    }
}
