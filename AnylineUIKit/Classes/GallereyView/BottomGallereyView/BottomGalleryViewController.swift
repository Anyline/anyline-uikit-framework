//
//  BottomGalleryViewController.swift
//  AnylineUIKit
//
//  Created by Mac on 10/22/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import UIKit

class BottomGalleryViewController: UIViewController {
    
    var presenter: BottomGalleryViewPresenterProtocol

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var firstPositionButton: UIButton!
    @IBOutlet weak var secondPositionButton: UIButton!
    @IBOutlet weak var thirdPositionButton: UIButton!
    @IBOutlet weak var fourthPositionButton: UIButton!
    @IBOutlet weak var fifthPositionButton: UIButton!
    @IBOutlet weak var listTopConstraint: NSLayoutConstraint!
    
    var bottomItems: [UIButton] = []
    
    var fullViewYPosition: CGFloat {
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0.0
        
        return UIScreen.main.bounds.height - contentView.frame.height - bottomPadding
    }

    var partialViewYPosition: CGFloat {
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0.0
        
        let bottomSheetViewHeight: CGFloat = 55.0
        let defaultTopTableViewConstraint: CGFloat = 20.0
        
        return UIScreen.main.bounds.height - (bottomSheetViewHeight + defaultTopTableViewConstraint + bottomPadding)
     }

    public override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)

        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        contentView.addGestureRecognizer(gesture)
        
        let nib = UINib(nibName: "BottomGallereyViewCell", bundle: Bundle(for: BottomGalleryViewController.self))
        tableView.register(nib, forCellReuseIdentifier: BottomGallereyViewCell.reuseIdentifier)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        setupBottomBar()
    }

    public init(presenter: BottomGalleryViewPresenterProtocol) {
        self.presenter = presenter
        let bundle = Bundle(for: BottomGalleryViewController.self)
        super.init(nibName: "BottomGalleryViewController", bundle: bundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension BottomGalleryViewController {
    
    func setupBottomBar() {
        let bottomGalleryBar = presenter.getBottomGalleryBar()
        tableView.separatorColor = presenter.getDivider()
        contentView.backgroundColor = presenter.getBackgroundBottomBar()
        bottomItems = [firstPositionButton, secondPositionButton, thirdPositionButton, fourthPositionButton, fifthPositionButton]
        
        for item in 0..<bottomGalleryBar.count {
            switch bottomGalleryBar[item] {
            case .delete:
                bottomItems[item].setupBaseBottomScanUIButton(imageName: "delete", selectedImageName: nil, tintColor: presenter.getTintControls())
                bottomItems[item].addTarget(self, action: #selector(onDeleteButton), for: .touchUpInside)
            case .rotateLeft:
                bottomItems[item].setupBaseBottomScanUIButton(imageName: "rotate-1", selectedImageName: nil, tintColor: presenter.getTintControls())
                bottomItems[item].addTarget(self, action: #selector(onTurnLeftButton), for: .touchUpInside)
            case .rotateRight:
                bottomItems[item].setupBaseBottomScanUIButton(imageName: "rotate", selectedImageName: nil, tintColor: presenter.getTintControls())
                bottomItems[item].addTarget(self, action: #selector(onTurnRightButton), for: .touchUpInside)
            case .crop:
                bottomItems[item].setupBaseBottomScanUIButton(imageName: "crop", selectedImageName: nil, tintColor: presenter.getTintControls())
                bottomItems[item].addTarget(self, action: #selector(onCropButton), for: .touchUpInside)
            case .newScan:
                bottomItems[item].setupBaseBottomScanUIButton(imageName: "camera", selectedImageName: nil, tintColor: presenter.getTintControls())
                bottomItems[item].addTarget(self, action: #selector(onNewScanButton), for: .touchUpInside)
            case .rearrange, .processing:
                break
            case .importImage:
                break
            case .empty:
                bottomItems[item].isHidden = true
            }
        }
    }
    
    private func moveView(state: Bool) {
        let yPosition = state == true ? partialViewYPosition : fullViewYPosition
        view.frame = CGRect(x: 0, y: yPosition, width: view.frame.width, height: view.frame.height)
    }

    private func moveView(panGestureRecognizer recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let minY = view.frame.minY

        if (minY + translation.y >= fullViewYPosition) && (minY + translation.y <= partialViewYPosition) {
            view.frame = CGRect(x: 0, y: minY + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: view)
        }
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        moveView(panGestureRecognizer: recognizer)

        if recognizer.state == .ended {
            UIView.animate(withDuration: 1, delay: 0.0, options: [.allowUserInteraction], animations: {
                let state: Bool = recognizer.velocity(in: self.contentView).y > 0 ? true : false
                self.moveView(state: state)
            }, completion: nil)
        }
    }
    
    @objc func onTurnRightButton() {
        presenter.turnRight()
    }
    
    @objc func onTurnLeftButton() {
        presenter.turnLeft()
    }
    
    @objc func onCropButton() {
        presenter.onCrop()
    }
    
    @objc func onDeleteButton() {
        presenter.onDelete()
    }
    
    @objc func onNewScanButton() {
        presenter.onNewScan()
    }
}

extension BottomGalleryViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let barExtension = presenter.getBottomGalleryExtensionBar()
        return barExtension.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BottomGallereyViewCell.reuseIdentifier, for: indexPath) as? BottomGallereyViewCell else { return UITableViewCell() }
        let barExtension = presenter.getBottomGalleryExtensionBar()
        switch barExtension[indexPath.row] {
        case .delete:
            break
        case .rotateLeft:
            break
        case .rotateRight:
            break
        case .crop:
            break
        case .newScan:
            break
        case .rearrange:
            cell.name = "Rearrange Images"
            cell.icon = "rearrange"
            cell.tintIconColor = presenter.getTintControls()
        case .importImage:
            cell.name = "Import Picture"
            cell.icon = "import"
            cell.tintIconColor = presenter.getTintControls()
        case .processing:
            cell.name = "Image Processing"
            cell.icon = "flashOn"
            cell.tintIconColor = presenter.getTintControls()
        case .empty:
            cell.name = ""
            cell.icon = nil
        }
        return cell
    }
}

extension BottomGalleryViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let barExtension = presenter.getBottomGalleryExtensionBar()
        switch barExtension[indexPath.row] {
        case .delete:
            break
        case .rotateLeft:
            break
        case .rotateRight:
            break
        case .crop:
            break
        case .newScan:
            break
        case .rearrange:
            presenter.onRearrangeImages()
        case .importImage:
            presenter.onImportPicture()
            break
        case .empty:
            break
        case .processing:
            presenter.onProcessingImage()
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension BottomGalleryViewController: BottomGalleryViewProtocol {
    
}
