//
//  RearrangeImagesCollectionViewCell.swift
//  AnylineUIKit
//
//  Created by Mac on 12/1/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import UIKit

class RearrangeImagesCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "rearrangeImagesCollectionViewCell"

    @IBOutlet weak var previewImageView: UIImageView!
    
    public var previewImage: UIImage? {
        didSet {
            guard let image = previewImage else { return }
            previewImageView.image = image
            previewImageView.contentMode = .scaleAspectFill
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        reset()
    }
}

private extension RearrangeImagesCollectionViewCell {
    func reset() {
        self.previewImageView?.image = nil
    }
}

