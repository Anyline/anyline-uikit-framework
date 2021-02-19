//
//  ScanView.swift
//  AnylineUIKit
//
//  Created by Mac on 10/19/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import UIKit
import Anyline

// Delegat for getting result documentSet from scan view
protocol ScanViewDelegate: AnyObject {
    func scanViewFinishedWithResult(documentSet: ALResultDocument)
}
// Main public class and start point for scanning documents
public class ScanView: UIViewController {
    
    let bottomViewController: BottomScanSheetView
    var documentConfig: DocumentScanViewConfig
    
    weak var delegate: ScanViewDelegate? = nil
    
    // Presenter of scan view containe prepared data for scan view
    var presenter: ScanViewPresenterProtocol
    var documentScanViewPlugin: ALDocumentScanViewPlugin?
    var documentScanPlugin: ALDocumentScanPlugin?
    var scanView: ALScanView!
    
    // Varible for checking state of error label (show/hide)
    var showingLabel = false
    
    // Variable for scan success
    private var isManualScanDone: Bool = true
    
    // Count of scanning pages
    var scanCount: Int = 0
    
    // Array of scaned pages
    var scanPagesForResult: [ResultPage] = []
    
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - Life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
        self.title = "ScanView"
        errorLabel.text = ""
        roundedView.alpha = 0
        roundedView.backgroundColor = presenter.getBackgroundHint()
        errorLabel.tintColor = presenter.getTextHint()
        self.view.backgroundColor = UIColor.white
        setupScanView()
        
        resetScanedPage()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startScanner()
        scanView.startCamera()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addBottomSheetView()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopScanner()
        scanView.stopCamera()
    }

    // Init with DocumentScanViewConfig class
    public init(documentConfig: DocumentScanViewConfig) {
        self.documentConfig = documentConfig
        self.presenter = ScanPresenter(documentConfig: documentConfig)
        let bottomPresenter = presenter.createBottomSheet()
        self.bottomViewController = BottomScanSheetView(presenter: bottomPresenter)
        super.init(nibName: "ScanView", bundle: Bundle(for: ScanView.self))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods of ScanView
private extension ScanView {
    private func startScanner() {
        do {
            try documentScanViewPlugin?.start()
            print("Scanner was STARTED")
        } catch {
            print("Scan start error: \(error.localizedDescription)")
        }
    }
    
    private func stopScanner() {
        do {
            try documentScanViewPlugin?.stop()
            print("Scanner was STOPED")
        } catch {
            print("Scan stop error: \(error.localizedDescription)")
        }
    }

    private func addBottomSheetView() {
        let width  = view.frame.width
        let height = bottomViewController.view.frame.height
        
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0.0
        
        let tempView = UIView()
        tempView.backgroundColor = .white
        self.view.addSubview(tempView)
        tempView.frame = CGRect(x: 0, y: self.view.frame.maxY - bottomPadding, width: width, height: bottomPadding)
        
        self.addChild(bottomViewController)
        self.view.addSubview(bottomViewController.view)
        bottomViewController.didMove(toParent: self)

        let bottomSheetViewHeight: CGFloat = 55.0
        let defaultTopTableViewConstraint: CGFloat = 20.0
        
        bottomViewController.tableViewTopConstraint.constant = bottomPadding + defaultTopTableViewConstraint
        
        bottomViewController.view.frame = CGRect(x: 0, y: self.view.frame.maxY - (bottomSheetViewHeight + defaultTopTableViewConstraint + bottomPadding), width: width, height: height)
        
        bottomViewController.moveCallback = { [weak self] state in
            if state == true {
                self?.presenter.updateOkButton(count: self?.scanCount ?? 0)
            }
        }
    }

    // Setup scan view with parametrs from presenter
    private func setupScanView() {
        viewPluginDocument()
        guard let cameraConfig = ALCameraConfig.defaultDocument() else {
            return
        }
        
        roundedView.layer.cornerRadius = 15
        self.scanView = ALScanView(frame: view.bounds, scanViewPlugin: documentScanViewPlugin, cameraConfig: cameraConfig, flashButtonConfig: ALFlashButtonConfig.defaultFlash())
        scanView.flashButton?.isHidden = true

        documentScanViewPlugin?.scanViewPluginConfig?.cancelOnResult = true
        self.documentScanPlugin?.postProcessingEnabled = false
        self.documentScanPlugin?.enableReporting(false)
        self.documentScanViewPlugin?.translatesAutoresizingMaskIntoConstraints = false

        updateRatioAndTolerance()
        setFlashStatus(status: presenter.getFlashStatus())
        
        view.addSubview(scanView)
        view.sendSubviewToBack(scanView)
        
        scanView.translatesAutoresizingMaskIntoConstraints = false
        
        scanView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scanView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scanView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scanView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    // Setup Document scan view plugin
    private func viewPluginDocument() {
        do {
            guard let configPath = Bundle.main.path(forResource: "document_view_config", ofType: "json") else { return  }
            guard let scanViewPluginConfig = ALScanViewPluginConfig(jsonFilePath: configPath) else { return  }
            guard let licenseKey = AnylineUIKit.shared.licenseKey else { return }
            
            self.documentScanPlugin = try ALDocumentScanPlugin(pluginID: "DOCUMENT", licenseKey: licenseKey, delegate: self)
            documentScanPlugin?.justDetectCornersIfPossible = false
            self.documentScanPlugin?.addInfoDelegate(self)
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

    // Notify users about warnning/errors
    private func showUserLabel(_ error: ALDocumentError) {
        var helpString: String? = nil

        switch error {
        case .unknown:
            helpString = "Unknown"
        case .outlineNotFound:
            helpString = "Outline not found"
        case .skewTooHigh:
            helpString = "Skew too high"
        case .glareDetected:
            helpString = "Glare detected"
        case .imageTooDark:
            helpString = "Image too dark"
        case .notSharp:
            helpString = "Not Sharp"
        case .shakeDetected:
            helpString = "Shake detected"
        case .ratioOutsideOfTolerance:
            helpString = "Ratio outside of tolerance"
        case .boundsOutsideOfTolerance:
            helpString = "Bounds outside of tolerance"
        case .dontMove:
            helpString = "Don't move"
        @unknown default:
            helpString = "Unknown"
        }
        
        // The error is not in the list above or a label is on screen at the moment
        if helpString == nil || showingLabel == true {
            return
        }
        
        showingLabel = true
        errorLabel.text = helpString
        

        // Animate the appearance of the label
        let fadeDuration: CGFloat = 0.8
        UIView.animate(withDuration: TimeInterval(fadeDuration), animations: { [weak self] in
            guard let self = self else {
                return
            }
            self.roundedView.alpha = 1
        }) { [weak self] finished in
            guard let self = self else {
                return
            }
            UIView.animate(withDuration: TimeInterval(fadeDuration), animations: { [weak self] in
                guard let self = self else {
                    return
                }
                self.roundedView.alpha = 0
            }) { [weak self] finished in
                guard let self = self else {
                    return
                }
                self.showingLabel = false
            }
        }
    }
}

extension ScanView: ScanViewProtocol {

    func onOkButton() {
//        stopScanner()
//        scanView.stopCamera()
        
        let documentSet = ALResultDocument(pages: scanPagesForResult)
        
        // If delegate is active return to previes screen with result documents
        if delegate != nil {
            print("pop to gallery")
            delegate?.scanViewFinishedWithResult(documentSet: documentSet)
            navigationController?.popViewController(animated: true)
        } else {
            print("start gallery")
            let galleryViewController = GalleryViewController(delegate: self, documentConfig: documentConfig, documentSet: documentSet)
            navigationController?.pushViewController(galleryViewController, animated: true)
        }
    }

    // Make empty scanPagesForResult array
    func resetScanedPage() {
        scanPagesForResult = []
        self.scanCount = 0
        self.presenter.updateOkButton(count: self.scanCount)
    }

    // Show paused label when scan process paused
    func showPaused(show: Bool) {
        if show {
            errorLabel.text = "Scanning paused"
            roundedView.alpha = 1
        } else {
            errorLabel.text = ""
            roundedView.alpha = 0
        }
        
    }
    
    // Action when user tap on cancel button
    func onCancelButton() {
        navigationController?.popViewController(animated: true)
    }
    
    // Action when user tap on maual button
    func onManualButton() {
        do {
            isManualScanDone = true
            try documentScanViewPlugin?.documentScanPlugin?.triggerPictureCornerDetection()
        } catch {
            print(error.localizedDescription)
            startScanner()
        }
    }

    func stopScanning() {
        stopScanner()
    }
    
    func startScanning() {
        startScanner()
    }
    
    // Getting Ratios tolerance and ratios from ScanPresenter and set it to documentScanPlugin
    func updateRatioAndTolerance() {
        documentScanPlugin?.maxDocumentRatioDeviation = presenter.getRatiosTolerance()
        documentScanPlugin?.documentRatios = presenter.getRatios()
    }
    
    // Getting Flash status (on/off/auto) and set it to flash status of scan view
    func setFlashStatus(status: ALFlashStatus) {
        scanView.flashButton?.flashStatus = status
    }
}

extension ScanView {
    private func updateDocumentSet(with scannedPage: ResultPage) {
        // If scan mode is singlePage show crop view with this page
        if presenter.getScanMode() == .singlePage {
            print("scanned sigle page")
//            scanView.stopCamera()
            
            let documentSet = ALResultDocument(pages: [scannedPage])
            delegate?.scanViewFinishedWithResult(documentSet: documentSet)
            
            let galleryViewController = GalleryViewController(documentConfig: documentConfig, documentSet: documentSet)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.navigationController?.pushViewController(galleryViewController, animated: true)
            }
        } else {
            // If scan mode is multiple update scanPagesForResult and scanCount (ok button)
            print("scanned multiple page")
            self.scanCount += 1
            self.scanPagesForResult.append(scannedPage)
            self.presenter.updateOkButton(count: self.scanCount)
            
            // Wait 3 seconds for starting scanning again
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3)) { [weak self] in
                guard let self = self else { return }
                
                self.startScanner()
            }
        }
    }
    
    private func backFromGalleryController(scannedPage: [ResultPage]) {
        
    }
}

extension ScanView: ALDocumentScanPluginDelegate {
    
    // Handle getting result from anylineDocumentScanPlugin for two modes (single/multiple)
    public func anylineDocumentScanPlugin(_ anylineDocumentScanPlugin: ALDocumentScanPlugin, hasResult transformedImage: UIImage, fullImage fullFrame: UIImage, documentCorners corners: ALSquare) {
        // set target size
        let targetSize = CGSize(
            width: presenter.getSize() ?? transformedImage.size.width,
            height: presenter.getSize() ?? transformedImage.size.height
        )
        
        // set image corners
        let imageCorners = RectangleFeature(
            topLeft: corners.upLeft,
            topRight: corners.upRight,
            bottomLeft: corners.downLeft,
            bottomRight: corners.downRight
        )
        
        // Create ALResultPage object
        let scannedPage = ResultPage(
            originalImage: fullFrame,
            transformedImage: transformedImage.resizeImage(targetSize: targetSize),
            imageCorners: imageCorners,
            autoWhiteBalance: presenter.getAutoWhiteBalanceEnabling() ?? false,
            autoContrast: presenter.getAutoContrastEnabling() ?? false,
            autoBrightness: presenter.getAutoBrightnessEnabling() ?? false,
            processingMode: presenter.getColorProcessing() ?? .color
        )
        
        stopScanner()
        
        updateDocumentSet(with: scannedPage)
    }
}

extension ScanView: ALDocumentInfoDelegate {
    public func anylineDocumentScanPluginTakePictureSuccess(_ anylineDocumentScanPlugin: ALDocumentScanPlugin) {
        print("anylineDocumentScanPluginTakePictureSuccess")
    }
    
    public func anylineDocumentScanPlugin(_ anylineDocumentScanPlugin: ALDocumentScanPlugin, reportsPictureProcessingFailure error: ALDocumentError) {
       showUserLabel(error)
    }
    
    public func anylineDocumentScanPlugin(_ anylineDocumentScanPlugin: ALDocumentScanPlugin, reportsPreviewProcessingFailure error: ALDocumentError) {
        showUserLabel(error)
    }
    
    // Handle image after tapping on manual button and show crop view
    public func anylineDocumentScanPlugin(_ anylineDocumentScanPlugin: ALDocumentScanPlugin, detectedPictureCorners corners: ALSquare, in image: UIImage) {
                
        if !isManualScanDone {
            self.isManualScanDone = true
            return
        }
        
        self.isManualScanDone = false
        
        // set image corners
        let imageCorners = RectangleFeature(
            topLeft: corners.upLeft,
            topRight: corners.upRight,
            bottomLeft: corners.downLeft,
            bottomRight: corners.downRight
        )
        
        let scannedPage = ResultPage(
            originalImage: image,
            transformedImage: nil,
            imageCorners: imageCorners,
            autoWhiteBalance: presenter.getAutoWhiteBalanceEnabling() ?? false,
            autoContrast: presenter.getAutoContrastEnabling() ?? false,
            autoBrightness: presenter.getAutoBrightnessEnabling() ?? false,
            processingMode: presenter.getColorProcessing() ?? .color
        )
        
        let cropPresenter = presenter.createCropPresenter()
        let cropView = CropViewController(page: scannedPage, presenter: cropPresenter) { [weak self] page in
            //crop image saved
            print("document set saaaaveee")
            self?.updateDocumentSet(with: page)
        }
        navigationController?.pushViewController(cropView, animated: true)
    }
}

extension ScanView: GalleryViewDelegate {
    
    func galleryViewFinishedWithResult(documentSet: ALResultDocument) {
        self.scanCount = documentSet.pages.count
        self.scanPagesForResult = documentSet.pages
        presenter.updateOkButton(count: self.scanCount)
    }
    
}
