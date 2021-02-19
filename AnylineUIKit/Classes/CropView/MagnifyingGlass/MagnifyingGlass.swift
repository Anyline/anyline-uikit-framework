//
//  magnifyingGlass.swift
//  AnylineUIKit
//
//  Created by Mac on 21.12.2020..
//  Copyright © 2020 Anyline. All rights reserved.
//

import UIKit

class MagnifyingGlass: UIView {
    // MARK: - Constants
    private struct Constants {
        static let fadeAnimationSpeed: TimeInterval = 0.2
        static let defaultMagnifierFactor: CGFloat = 1.5
    }

    // MARK: - Properties
    private var targetView: UIView
    private var magnifyingImageView: UIImageView

    var magnifyingFactor: CGFloat {
        didSet {
            setupMagnifyingImageView()
        }
    }
    
    // MARK: - UIView
    init(frame: CGRect, targetView: UIView) {
        
        self.targetView = targetView
        self.magnifyingFactor = Constants.defaultMagnifierFactor
        self.magnifyingImageView = UIImageView(image: targetView.snapshot)
        
        super.init(frame: frame)
        

        // set up magnifying image view
        self.addSubview(magnifyingImageView)
        self.setupMagnifyingImageView()

        // setup glass view
        self.clipsToBounds = true
        self.backgroundColor = .darkGray

        // add little focus point view
        let focusPointView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 8))
        focusPointView.center = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)
        focusPointView.backgroundColor = .clear
        focusPointView.layer.cornerRadius = 4.0
        focusPointView.layer.borderWidth = 1.0
        focusPointView.layer.borderColor = UIColor(red:0.1887, green: 0.2281, blue: 0.6502, alpha: 1.0).cgColor
        self.addSubview(focusPointView)

        // hide magnifying glass initially
        self.dismiss(animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(animated: Bool) {
        UIView.animate(
            withDuration: (animated ? Constants.fadeAnimationSpeed : 0),
            delay: 0,
            options: .beginFromCurrentState,
            animations: { [weak self] in
                guard let self = self else { return }
                self.alpha = 1.0
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    }

    func dismiss(animated: Bool) {
        UIView.animate(
            withDuration: (animated ? Constants.fadeAnimationSpeed : 0),
            delay:0,
            options: .beginFromCurrentState,
            animations: { [weak self] in
                guard let self = self else { return }
                self.alpha = 0.0
                self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: nil)
    }

    func magnify(focusPoint: CGPoint) {
        let x = -focusPoint.x * magnifyingFactor + magnifyingImageView.frame.size.width/2 + self.frame.size.width/2
        let y = -focusPoint.y * magnifyingFactor + magnifyingImageView.frame.size.height/2 + self.frame.size.height/2
        
        self.magnifyingImageView.center = CGPoint(x: x, y: y)
    }

    func refreshInput() {
        magnifyingImageView.image = targetView.snapshot
        setupMagnifyingImageView()
    }

    private func setupMagnifyingImageView() {
        magnifyingImageView.frame = CGRect(
            x: 0.0,
            y: 0.0,
            width: self.targetView.frame.size.width * magnifyingFactor,
            height: self.targetView.frame.size.height * magnifyingFactor
        )
        magnifyingImageView.center = CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height / 2.0)
    }
}

