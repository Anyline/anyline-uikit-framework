//
//  SelectSizeTableViewCell.swift
//  AnylineUIKit
//
//  Created by Mac on 11/16/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import UIKit

class SelectSizeTableViewCell: UITableViewCell {
    static let reuseIdentifier = "selectSizeTableViewCellIdentificator"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkedImageView: UIImageView!
    public var name: String? {
        didSet {
            guard let name = name else {
                return
            }
            nameLabel.text = name
        }
    }
    
    public var isRadioSelected: Bool? {
        didSet {
            guard let isRadioSelected = isRadioSelected else {
                return
            }
            checkedImageView.isHidden = !isRadioSelected
        }
    }
    
    override func prepareForReuse() {
        reset()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.font = nameLabel.font.withSize(15)
    }
}

private extension SelectSizeTableViewCell {
    func reset() {
        self.nameLabel?.text = ""
    }
}
