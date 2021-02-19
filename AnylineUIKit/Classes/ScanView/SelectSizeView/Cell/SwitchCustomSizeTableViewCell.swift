//
//  SwitchCustomSizeTableViewCell.swift
//  AnylineUIKit
//
//  Created by Mac on 11/17/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import UIKit

protocol SwitchCustomSizeTableViewCellDelegate: class {
    func didChangeCustomSwitch(isOn: Bool)
}

class SwitchCustomSizeTableViewCell: UITableViewCell {
    static let reuseIdentifier = "switchCustomSizeTableViewCellIdentificator"

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
    weak var delegate: SwitchCustomSizeTableViewCellDelegate?

    @IBAction func onSwitchButton(_ sender: UISwitch) {
        delegate?.didChangeCustomSwitch(isOn: sender.isOn)
    }

    public var name: String? {
        didSet {
            guard let name = name else {
                return
            }
            nameLabel.text = name
        }
    }
    
    override func prepareForReuse() {
        reset()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.font = nameLabel.font.withSize(15)
        switchButton.onTintColor = UIColor.Base.blue
        switchButton.tintColor = UIColor.Base.gray
    }    
}

private extension SwitchCustomSizeTableViewCell {
    func reset() {
        self.nameLabel?.text = ""
    }
}
