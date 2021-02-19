//
//  GalleryViewController.swift
//  AnylineUIKit
//
//  Created by Mac on 10/19/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import UIKit
import SnapKit
import Anyline

// Delegate with result of current session of Gallery view
protocol GalleryViewDelegate: AnyObject {
    func galleryViewFinishedWithResult(documentSet: ALResultDocument)
}

class GalleryViewController: UIViewController, UIScrollViewDelegate {
    
    let bottomViewController: BottomGalleryViewController
    var imagePicker: ImagePicker?
    var scannedPages: [ResultPage]
    var documentSet: ALResultDocument
    var pageViews: [UIImageView] = []
    var presenter: GalleryViewPresenterProtocol
    
    var textField = UITextField()
    
    var importedImage: UIImage?

    var documentScanPlugin: ALDocumentScanPlugin?
    var documentScanViewPlugin: ALDocumentScanViewPlugin?
    
    weak var delegate: GalleryViewDelegate? = nil
    
    lazy var scrollView = UIScrollView()
    
    private enum RotatingDirection {
        case none, left, right
    }
    private var rotatingDirection: RotatingDirection = .none
    
    private let animatorBtnRotate: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 2, curve: .easeInOut)
    private let animatorBtnDelete: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 2, curve: .easeInOut)
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnRotateAll: UIButton!
    @IBOutlet weak var btnDeleteAll: UIButton!
    
    init(delegate: GalleryViewDelegate? = nil, documentConfig: DocumentScanViewConfig, documentSet: ALResultDocument) {
        self.delegate = delegate
        self.documentSet = documentSet
        self.scannedPages = documentSet.pages
        self.presenter = GalleryPresenter(documentConfig: documentConfig)
        let bottomPresenter = presenter.createBottomGalleryPresenter()
        bottomViewController = BottomGalleryViewController(presenter: bottomPresenter)
        
        super.init(nibName: "GalleryViewController", bundle: Bundle(for: GalleryViewController.self))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDismissKeyboardOnTap()
        navigationController?.setupDismissKeyboardOnTap()
        presenter.attachView(self)
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        view.backgroundColor = .white
        scrollView.delegate = self
        pageControl.currentPage = 0
        
        navigationItem.titleView = textField
        viewPluginDocument()
        

        self.textField.text = documentSet.nameOfSet
        self.view.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadScrollView()
        addBottomSheetView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        updateDocumentSet()
    }
    
    private func updateDocumentSet() {
        documentSet.pages = scannedPages
        documentSet.nameOfSet = textField.text ?? " "
        delegate?.galleryViewFinishedWithResult(documentSet: documentSet)
    }

    
    @IBAction func actionRotateAll(_ sender: UIButton) {
        switch rotatingDirection {
        case .left:
            self.applyRotateLeftForAllPages()
            
        case .right:
            self.applyRotateRightForAllPages()
            
        case .none:
            // do nothing
            break
        }
    }
    
    @IBAction func actionDeleteAll(_ sender: UIButton) {
        let actionYes = UIAlertAction(
            title: "Yes",
            style: .destructive,
            handler: { [weak self] (action) in
                guard let self = self else { return }
            
                self.scannedPages = []
                self.navigationController?.popViewController(animated: true)
            }
        )
        
        let actionCancel = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        
        let actionSheet = UIAlertController(title: "Are you sure?", message: "Are you sure you want to delete all other documents?", preferredStyle: .actionSheet)
        actionSheet.addAction(actionYes)
        actionSheet.addAction(actionCancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func btnRotateShow() {
        if animatorBtnRotate.state == .active {
            animatorBtnRotate.stopAnimation(false)
            animatorBtnRotate.finishAnimation(at: .end)
        }
        
        animatorBtnRotate.addAnimations { [unowned self] in
            self.btnRotateAll.alpha = 0.05
        }
        animatorBtnRotate.addCompletion { position in
            self.btnRotateAll.isHidden = true
        }
        
        btnRotateAll.alpha = 1
        btnRotateAll.isHidden = false
        view.bringSubviewToFront(btnRotateAll)
        animatorBtnRotate.startAnimation()
    }
    
    private func btnDeleteShow() {
        if animatorBtnDelete.state == .active {
            animatorBtnDelete.stopAnimation(false)
            animatorBtnDelete.finishAnimation(at: .end)
        }
        
        animatorBtnDelete.addAnimations { [unowned self] in
            self.btnDeleteAll.alpha = 0.05
        }
        animatorBtnDelete.addCompletion { position in
            self.btnDeleteAll.isHidden = true
        }
        
        btnDeleteAll.alpha = 1
        self.btnDeleteAll.isHidden = false
        view.bringSubviewToFront(btnDeleteAll)
        animatorBtnDelete.startAnimation()
    }
    
    // Setup Document scan view plugin
    private func viewPluginDocument() {
        do {
            guard let configPath = Bundle.main.path(forResource: "document_view_config", ofType: "json") else { return }
            guard let scanViewPluginConfig = ALScanViewPluginConfig(jsonFilePath: configPath) else { return }
            guard let licenseKey = AnylineUIKit.shared.licenseKey else { return }
            
            self.documentScanPlugin = try ALDocumentScanPlugin(pluginID: "DOCUMENT", licenseKey: licenseKey, delegate: self)
            documentScanPlugin?.justDetectCornersIfPossible = false
            guard let scanPlugin = self.documentScanPlugin else {
                return
            }
            self.documentScanViewPlugin = ALDocumentScanViewPlugin(scanPlugin: scanPlugin, scanViewPluginConfig: scanViewPluginConfig)
            documentScanViewPlugin?.scanViewPluginDelegates?.add(self)
            documentScanViewPlugin?.setValue(self, forKey: "tmpOutlineDelegate")
        } catch {
            print("Scan setup error: \(error.localizedDescription)")
        }
    }

    func loadScrollView() {
        let pageCount = scannedPages.count
        let height = view.frame.height
        let width  = view.frame.width
        scrollView.frame = CGRect(x: 0, y: 100, width: width, height: height - 170)
        
        pageViews.forEach { (page) in
            page.removeFromSuperview()
        }
        pageViews = []
        scrollView.removeFromSuperview()
        
        scrollView.backgroundColor = UIColor.clear
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false

        pageControl.numberOfPages = pageCount
        pageControl.pageIndicatorTintColor = presenter.getTintColorDisabled()
        pageControl.currentPageIndicatorTintColor = presenter.getTintColor()
        
        if #available(iOS 14, *) {
            pageControl.backgroundStyle = .minimal
        }

        for item in (0..<pageCount) {

            let pageView = UIImageView()
            pageView.frame.origin.x = scrollView.frame.size.width * CGFloat(item)
            pageView.frame.size = scrollView.frame.size
            pageView.contentMode = .scaleAspectFit
            pageView.image = scannedPages[item].ocrOptimisedImage
            
            pageViews.append(pageView)
            self.scrollView.addSubview(pageView)
        }
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(scannedPages.count)),
                                        height: scrollView.frame.size.height)
        view.addSubview(scrollView)
        view.bringSubviewToFront(bottomViewController.view)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
        /*
         * below code scales the imageview on paging the scrollview
         */
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        
        let step = 1.0 / (Double(pageViews.count) - 1.0)
        var dictStepsAndOfset:[Int: Double] = [:]
        var steps = 0.0
        for item in 0..<pageViews.count {
            dictStepsAndOfset.updateValue(steps, forKey: item)
            steps += step
        }
        
        let arrayDict = dictStepsAndOfset.sorted(by: { $0.0 < $1.0 })
        
        arrayDict.forEach { key, value in
            if value == 0 {
                if(percentOffset.x > CGFloat(value) && (percentOffset.x <= CGFloat(step))) {
                    pageViews[key].transform = CGAffineTransform(scaleX: (CGFloat(step)-percentOffset.x)/CGFloat(step), y: (CGFloat((step))-percentOffset.x)/CGFloat(step))
                    pageViews[key+1].transform = CGAffineTransform(scaleX: percentOffset.x/CGFloat((step+value)), y: percentOffset.x/CGFloat((step+value)))
                }
            } else if key < pageViews.count - 1 {
                if(percentOffset.x > CGFloat(value) && percentOffset.x <= CGFloat(value + step)) {
                    pageViews[key].transform = CGAffineTransform(scaleX: (CGFloat((value+step))-percentOffset.x)/CGFloat(step), y: (CGFloat((value+step))-percentOffset.x)/CGFloat(step))
                    pageViews[key + 1].transform = CGAffineTransform(scaleX: percentOffset.x/CGFloat((step+value)), y: percentOffset.x/CGFloat(step+value))
                }
            }
        }
    }

    func addBottomSheetView() {
        self.addChild(bottomViewController)
        self.view.addSubview(bottomViewController.view)
        bottomViewController.didMove(toParent: self)

        let width  = view.frame.width
        let height: CGFloat =  bottomViewController.view.frame.height
        
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0.0
        
        let bottomSheetViewHeight: CGFloat = 55.0
        let defaultTopTableViewConstraint: CGFloat = 20.0
        
        bottomViewController.listTopConstraint.constant = bottomPadding + defaultTopTableViewConstraint
        
        bottomViewController.view.frame = CGRect(x: 0, y: self.view.frame.maxY - (bottomSheetViewHeight + defaultTopTableViewConstraint + bottomPadding), width: width, height: height)
        
    }
}

extension GalleryViewController: GalleryViewProtocol {

    func showImageProcessing(documentConfig: DocumentScanViewConfig, galleryPresenter: GalleryPresenter) {
        let presenter = ImageProcessingPresenter(documentConfig: documentConfig, scannedPages: scannedPages, indexOfCurrentPage: pageControl.currentPage)
        presenter.resultDelegate = galleryPresenter
        let view = ImageProcessingViewController(presenter: presenter)
        let navigationView = UINavigationController(rootViewController: view)
        present(navigationView, animated: true, completion: nil)
    }

    func updatePages(pages: [ResultPage]) {
        scannedPages = pages
        loadScrollView()
    }
    
    func showImportImage() {
        imagePicker?.present()
    }
    
    func showNewScan() {
//        let scanView = presenter.createScanView()
//        scanView.delegate = self
//        navigationController?.pushViewController(scanView, animated: true)
        
        navigationController?.popViewController(animated: true)
    }

    func deletePage() {
        scannedPages.remove(at: pageControl.currentPage)
        loadScrollView()
        
        if scannedPages.count == 0 {
            navigationController?.popViewController(animated: true)
        } else if scannedPages.count >= 2 {
            btnDeleteShow()
        }
    }

    func showRearrangeView() {
        let rearrangePresenter = presenter.createRearangeImagesViewPresenter()
        let rearrangeView = RearrangeImagesView(presenter: rearrangePresenter, scannedPages: scannedPages)
    
        navigationController?.pushViewController(rearrangeView, animated: true)
    }
    
    func showCropView() {
        let cropPresenter = presenter.createCropViewPresenter()
        let cropViewController = CropViewController(page: scannedPages[pageControl.currentPage], presenter: cropPresenter) { [weak self] page in
            guard let self = self else { return }
            
            self.scannedPages[self.pageControl.currentPage] = page
            self.updatePages(pages: self.scannedPages)
        }
        navigationController?.pushViewController(cropViewController, animated: true)
    }
    
    func turnLeft() {
        scannedPages[pageControl.currentPage].rotatePageCounterClockwise()
        self.pageViews[self.pageControl.currentPage].image = self.scannedPages[self.pageControl.currentPage].ocrOptimisedImage
        
        if scannedPages.count >= 2 {
            rotatingDirection = .left
            btnRotateShow()
        }
    }
    
    func turnRight() {
        scannedPages[pageControl.currentPage].rotatePageClockwise()
        self.pageViews[self.pageControl.currentPage].image = self.scannedPages[self.pageControl.currentPage].ocrOptimisedImage
        
        if scannedPages.count >= 2 {
            rotatingDirection = .right
            btnRotateShow()
        }
    }
}

extension GalleryViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {

        guard let image = image else {
            return
        }
        
        importedImage = image
        do {
         try documentScanPlugin?.start(self)
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
}

private extension GalleryViewController {
    func applyRotateLeftForAllPages() {
        for item in 0...scannedPages.count - 1 {
            if item != pageControl.currentPage {
                scannedPages[item].rotatePageCounterClockwise()
                self.pageViews[item].image = self.scannedPages[item].ocrOptimisedImage
            }
        }
    }
    
    func applyRotateRightForAllPages() {
        for item in 0...scannedPages.count - 1 {
            if item != pageControl.currentPage {
                scannedPages[item].rotatePageClockwise()
                self.pageViews[item].image = self.scannedPages[item].ocrOptimisedImage
            }
        }
    }
}

extension GalleryViewController: ScanViewDelegate {
    func scanViewFinishedWithResult(documentSet: ALResultDocument) {
        let pages = documentSet.pages
        pages.forEach { (page) in
            scannedPages.append(page)
        }
        loadScrollView()
    }
}

extension GalleryViewController: ALDocumentScanPluginDelegate {
    
    // Handle getting result from anylineDocumentScanPlugin for two modes (single/multiple)
    public func anylineDocumentScanPlugin(_ anylineDocumentScanPlugin: ALDocumentScanPlugin, hasResult transformedImage: UIImage, fullImage fullFrame: UIImage, documentCorners corners: ALSquare) {
        // set image corners
        let imageCorners = RectangleFeature(
            topLeft: corners.upLeft,
            topRight: corners.upRight,
            bottomLeft: corners.downLeft,
            bottomRight: corners.downRight
        )
        
        let page = ResultPage(
            originalImage: fullFrame,
            transformedImage: transformedImage,
            imageCorners: imageCorners,
            autoWhiteBalance: presenter.getAutoWhiteBalanceEnabling() ?? false,
            autoContrast: presenter.getAutoContrastEnabling() ?? false,
            autoBrightness: presenter.getAutoBrightnessEnabling() ?? false,
            processingMode: presenter.getColorProcessing() ?? .color
        )
        
        scannedPages.append(page)
        loadScrollView()
        do {
         try documentScanPlugin?.stop()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension GalleryViewController: ALImageProvider {
    func provideNewImage(completionBlock completionHandler: ALImageProviderBlock!) {
        
        // sample image - use the real one
        if let image = importedImage {
            let alImage = ALImage(uiImage: image)
            let alFullImage = ALImage(uiImage: image)
            
            completionHandler(alImage, alFullImage, .zero, nil)
        } else {
            completionHandler(nil, nil, .zero, nil)
        }
    }
    
    func provideNewFullResolutionImage(completionBlock completionHandler: ALImageProviderBlock!) {
        // sample image - use the real one
        if let image = importedImage {
            let alImage = ALImage(uiImage: image)
            let alFullImage = ALImage(uiImage: image)
            
            completionHandler(alImage, alFullImage, .zero, nil)
        } else {
            completionHandler(nil, nil, .zero, nil)
        }
    }
    
    func provideNewStillImage(completionBlock completionHandler: ALImageProviderBlock!) {
        // sample image - use the real one
        if let image = importedImage {
            let alImage = ALImage(uiImage: image)
            let alFullImage = ALImage(uiImage: image)
            
            completionHandler(alImage, alFullImage, .zero, nil)
        } else {
            completionHandler(nil, nil, .zero, nil)
        }
    }
}
