//
//  CustomSizeTableViewCell.swift
//  AnylineUIKit
//
//  Created by Mac on 11/17/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import UIKit

protocol CustomSizeTableViewCellDelegate: class {
    func customSizeDidChange(customSize: String)
}

class CustomSizeTableViewCell: UITableViewCell {

    static let reuseIdentifier = "customSizeTableViewCellIdentificator"

    @IBOutlet weak var customSizeTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    
    weak var delegate: CustomSizeTableViewCellDelegate?
    
    public var customSizeText: String? {
        didSet {
            guard let customSizeText = customSizeText else {
                return
            }
            customSizeTextField.text = customSizeText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.textColor = UIColor.Base.textGray
        nameLabel.text = "Pixels"
        customSizeTextField.addTarget(self, action: #selector(customSizeTextFieldDidChange), for: .editingChanged)
        nameLabel.font = nameLabel.font.withSize(15)
        customSizeTextField.keyboardType = .numberPad
        customSizeTextField.borderStyle = .none
    }
    
    override func prepareForReuse() {
        reset()
    }
    
    @objc func customSizeTextFieldDidChange() {
        delegate?.customSizeDidChange(customSize: customSizeTextField.text ?? "")
    }
}

private extension CustomSizeTableViewCell {
    func reset() {
        self.customSizeTextField?.text = ""
        nameLabel.text = ""
    }
}
