//
//  CropViewController.swift
//  AnylineUIKit
//
//  Created by Mac on 10/19/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import UIKit

class CropViewController: UIViewController {

    let bottomViewController: BottomCropViewController
    
    var page: ResultPage
    var presenter: CropViewPresenterProtocol
    
    var cropCompleted: ((ResultPage) -> Void)?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageImageView: UIImageView!
    @IBOutlet weak var croppingView: CroppingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
        self.title = "Crop View"
        self.view.backgroundColor = UIColor.white
        
        // styling
        containerView.backgroundColor = UIColor.clear
        pageImageView.backgroundColor = UIColor.clear
        croppingView.backgroundColor = UIColor.clear
        
        // set image
        if let cgImage = page.originalImage?.cgImage, let scale = page.originalImage?.scale {
            pageImageView.image = UIImage(cgImage: cgImage, scale: scale, orientation: .up)
        }
        
        // setup cropping view
        croppingView.page = page
        croppingView.relatedImageView = pageImageView
        croppingView.croppingViewStateChangedHandler = { [weak self] croppingAreaValid in
            guard let self = self else {
                return
            }
            if croppingAreaValid {
                //self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.completeCroppingAction)), animated: true)
                self.presenter.updateOk(isEnabled: true)
            } else {
                //self.navigationItem.setRightBarButton(nil, animated: true)
                self.presenter.updateOk(isEnabled: false)
            }
        }
        
        // setup magnifying glass
        let glass = MagnifyingGlass(frame: CGRect(x: 0, y: 0, width: 100, height: 100), targetView: pageImageView)
        glass.magnifyingFactor = 2.0
        glass.layer.cornerRadius = 50
        glass.layer.borderWidth = 2.0
        glass.layer.borderColor = UIColor.white.cgColor

        croppingView.magnifyingGlass = glass
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBottomSheetView()
    }

    init(page: ResultPage, presenter: CropViewPresenterProtocol, cropCompleted: ((ResultPage) -> Void)? = nil) {
        self.page = page
        self.presenter = presenter
        self.cropCompleted = cropCompleted
        let bottomPresenter = presenter.createBottomSheet()
        bottomViewController = BottomCropViewController(presenter: bottomPresenter)
        super.init(nibName: "CropViewController", bundle: Bundle(for: CropViewController.self))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addBottomSheetView() {
        self.addChild(bottomViewController)
        self.view.addSubview(bottomViewController.view)
        bottomViewController.didMove(toParent: self)

        let height = view.frame.height
        let width  = view.frame.width
        bottomViewController.view.frame = CGRect(x: 0, y: self.view.frame.maxY - height / 10, width: width, height: height / 10)
    }
}

extension CropViewController: CropViewProtocol {
    func getCropPage() -> ResultPage {
        return page
    }
    
    func cancel() {
        navigationController?.popViewController(animated: true)
    }

    func completeCroppingAction() {
        page.imageCorners = croppingView.updatedImageCorners()
        
        if let ocrOptimisedImage = page.ocrOptimisedImage {
            page.ocrOptimisedImage = presenter.setPostProcessing(image: ocrOptimisedImage)
        }
        
        self.cropCompleted?(page)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        print("Changed")
    }
}
