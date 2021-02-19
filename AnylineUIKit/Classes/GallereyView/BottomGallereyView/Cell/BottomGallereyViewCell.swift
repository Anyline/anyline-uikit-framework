//
//  BottomGallereyViewCell.swift
//  AnylineUIKit
//
//  Created by Mac on 10/22/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import UIKit

class BottomGallereyViewCell: UITableViewCell {
    static let reuseIdentifier = "bottomGallereyViewCell"

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    public var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    public var tintIconColor: UIColor? {
        didSet {
            guard let color = tintIconColor else { return }
            iconImageView.tintColor = color
        }
    }

    public var icon: String? {
        didSet {
            guard let image = icon else { return }
            let bundle = Bundle(for: BottomScanSheetViewCell.self)
            iconImageView.image = UIImage(named: image, in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            iconImageView.tintColor = UIColor.Base.pink
            iconImageView.contentMode = .scaleAspectFill
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.font = nameLabel.font.withSize(12)
        self.backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        reset()
    }
}

private extension BottomGallereyViewCell {
    func reset() {
        self.iconImageView?.image = nil
        self.nameLabel.text = ""
    }
}
