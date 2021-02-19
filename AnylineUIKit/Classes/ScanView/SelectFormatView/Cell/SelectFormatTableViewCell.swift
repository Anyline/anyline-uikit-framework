//
//  SelectFormatTableViewCell.swift
//  AnylineUIKit
//
//  Created by Mac on 11/16/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import UIKit

protocol SelectFormatTableViewCellDelegate: class {
    func shortSideDidChange(shortSide: String)
    func longSideDidChange(longSide: String)
}

class SelectFormatTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var shortSideTextField: UITextField!
    @IBOutlet weak var longSideTextField: UITextField!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    
    weak var delegate: SelectFormatTableViewCellDelegate?
    

    static let reuseIdentifier = "selectFormatTableViewCellIdentificator"

    public var name: String? {
        didSet {
            guard let name = name else {
                return
            }
            nameLabel.text = name
        }
    }
    
    public var isBoxSelected: Bool? {
        didSet {
            guard let isBoxSelected = isBoxSelected else {
                return
            }
            let bundle = Bundle(for: BottomScanSheetView.self)
            if isBoxSelected {
                let imageSelected = UIImage(named: "checkSelected", in: bundle, compatibleWith: nil)
                checkBoxImageView.image = imageSelected
            } else {
                let imageUnselected = UIImage(named: "checkUnselected", in: bundle, compatibleWith: nil)
                checkBoxImageView.image = imageUnselected
            }
        }
    }
    
    public var isCustomCell: Bool? {
        didSet {
            guard let isCustomCell = isCustomCell else {
                return
            }
            if isCustomCell {
                separatorLabel.isHidden = false
                shortSideTextField.isHidden = false
                longSideTextField.isHidden = false
            } else {
                separatorLabel.isHidden = true
                shortSideTextField.isHidden = true
                longSideTextField.isHidden = true
            }
        }
    }
    
    public var shortSideText: String? {
        didSet {
            guard let shortSideText = shortSideText else {
                return
            }
            shortSideTextField.text = shortSideText
        }
    }
    
    public var longSideText: String? {
        didSet {
            guard let longSideText = longSideText else {
                return
            }
            longSideTextField.text = longSideText
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        shortSideTextField.keyboardType = .numberPad
        longSideTextField.keyboardType = .numberPad
        nameLabel.font = nameLabel.font.withSize(15)
        
        separatorLabel.textColor = UIColor.Base.textGray
        separatorLabel.text = ":"
        
        shortSideTextField.borderStyle = .none
        longSideTextField.borderStyle = .none
        
        shortSideTextField.addTarget(self, action: #selector(shortSideTextFieldDidChange), for: .editingChanged)
        longSideTextField.addTarget(self, action: #selector(longSideTextFieldDidChange), for: .editingChanged)
        
        separatorLabel.isHidden = true
        shortSideTextField.isHidden = true
        longSideTextField.isHidden = true
        
        shortSideTextField.layer.cornerRadius = 10
        longSideTextField.layer.cornerRadius = 10
    }
    
    @objc func shortSideTextFieldDidChange() {
        delegate?.shortSideDidChange(shortSide: shortSideTextField.text ?? "")
    }

    @objc func longSideTextFieldDidChange() {
        delegate?.longSideDidChange(longSide: longSideTextField.text ?? "")
    }
    
    override func prepareForReuse() {
        reset()
    }
}

private extension SelectFormatTableViewCell {
    func reset() {
        nameLabel.text = ""
//        separatorLabel.text = ""
        shortSideTextField.text = ""
        longSideTextField.text = ""
        checkBoxImageView.image = nil
    }
}
