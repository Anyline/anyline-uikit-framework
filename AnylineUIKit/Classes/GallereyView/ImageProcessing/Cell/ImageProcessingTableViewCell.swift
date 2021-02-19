//
//  ImageProcessingTableViewCell.swift
//  AnylineUIKit
//
//  Created by Mac on 12/7/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import UIKit

class ImageProcessingTableViewCell: UITableViewCell {
    static let reuseIdentifier = "imageProcessingTableViewCellIdentificator"
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
        // Initialization code
    }
}

private extension ImageProcessingTableViewCell {
    func reset() {
        self.nameLabel?.text = ""
    }
}
