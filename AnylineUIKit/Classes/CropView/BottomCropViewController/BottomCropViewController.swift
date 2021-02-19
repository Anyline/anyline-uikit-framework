//
//  BottomCropViewController.swift
//  AnylineUIKit
//
//  Created by Mac on 10/22/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import UIKit

class BottomCropViewController: UIViewController {
    
    var presenter: BottomCropViewPresenterProtocol

    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
        self.view.backgroundColor = presenter.getBackgroundBottomBar()
        okButton.setupBaseBottomScanUIButton(imageName: "ok", selectedImageName: nil, tintColor: presenter.getTintControls())
        cancelButton.setupBaseBottomScanUIButton(imageName: "cancel", selectedImageName: nil, tintColor: presenter.getTintControls())
    }
    init(presenter: BottomCropViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "BottomCropViewController", bundle: Bundle(for: BottomCropViewController.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension BottomCropViewController {
    @IBAction func onOkButton(_ sender: UIButton) {
        presenter.onOkButton()
    }
    @IBAction func onCancelButton(_ sender: UIButton) {
        presenter.onCancelButton()
    }
}

extension BottomCropViewController: BottomCropViewProtocol {
    func setupOkButton(isEnabled: Bool) {
        okButton.isEnabled = isEnabled
    }
}
