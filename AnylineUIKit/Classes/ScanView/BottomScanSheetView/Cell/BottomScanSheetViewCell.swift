//
//  BottomScanSheetViewCell.swift
//  AnylineUIKit
//
//  Created by Mac on 10/21/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import UIKit

public class BottomScanSheetViewCell: UITableViewCell {
    static let reuseIdentifier = "bottomScanSheetViewCellIdentificator"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
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
            iconImageView.contentMode = .scaleAspectFill
        }
    }
    
    public override func prepareForReuse() {
        reset()
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.font = nameLabel.font.withSize(12)
        self.backgroundColor = .clear
    }
}

private extension BottomScanSheetViewCell {
    func reset() {
        nameLabel.text = ""
        iconImageView.image = nil
    }
}
