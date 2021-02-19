//
//  RearrangeImagesView.swift
//  AnylineUIKit
//
//  Created by Mac on 12/1/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import UIKit

class RearrangeImagesView: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var okButton: UIButton!
    
    var longPressGesture : UILongPressGestureRecognizer!

    var presenter: RearrangeImagesViewPresenterProtocol
    
    var scannedPages: [ResultPage]

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
        bottomView.backgroundColor = presenter.getBackgroundBottomBar()
        
        let nib = UINib(nibName: "RearrangeImagesCollectionViewCell", bundle: Bundle(for: RearrangeImagesCollectionViewCell.self))
        collectionView.register(nib, forCellWithReuseIdentifier: RearrangeImagesCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
    
        okButton.setupBaseBottomScanUIButton(imageName: "ok", selectedImageName: nil, tintColor: presenter.getTintControls())
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:)))
            self.collectionView?.addGestureRecognizer(longPressGesture)
    }
    
    init(presenter: RearrangeImagesPresenter, scannedPages: [ResultPage]) {
        self.presenter = presenter
        self.scannedPages = scannedPages
        super.init(nibName: "RearrangeImagesView", bundle: Bundle(for: RearrangeImagesView.self))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension RearrangeImagesView {

    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {

        switch(gesture.state) {

        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.collectionView?.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
                break
            }
            collectionView?.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            collectionView?.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            collectionView?.endInteractiveMovement()
        default:
            collectionView?.cancelInteractiveMovement()
        }
    }

    @IBAction func onOkButton(_ sender: UIButton) {
        presenter.saveOrderPages(pages: scannedPages)
        navigationController?.popViewController(animated: true)
    }
}

extension RearrangeImagesView: RearrangeImagesViewProtocol {
}

extension RearrangeImagesView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scannedPages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RearrangeImagesCollectionViewCell.reuseIdentifier, for: indexPath) as? RearrangeImagesCollectionViewCell else { return UICollectionViewCell() }
        cell.previewImage = scannedPages[indexPath.row].ocrOptimisedImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let temp = scannedPages.remove(at: sourceIndexPath.item)
        scannedPages.insert(temp, at: destinationIndexPath.item)
    }
}

extension RearrangeImagesView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ( self.collectionView.frame.size.width - 80 ) / 3, height:( self.collectionView.frame.size.width - 80 ) / 3)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
    }
}
