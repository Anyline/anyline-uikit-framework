//
//  ImageProcessingPresenter.swift
//  AnylineUIKit
//
//  Created by Mac on 12/4/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation
import CoreImage
import Anyline

class ImageProcessingPresenter {
    var documentConfig: DocumentScanViewConfig
    private weak var view: ImageProcessingViewProtocol?
    
    var scannedPages: [ResultPage]
    var defaultPageImage: UIImage?
    var indexOfCurrentPage: Int

    weak var resultDelegate: ImageProcessingPresenterResultProtocol? = nil
    
    init(documentConfig: DocumentScanViewConfig, scannedPages: [ResultPage], indexOfCurrentPage: Int) {
        self.documentConfig = documentConfig
        self.scannedPages = scannedPages
        self.indexOfCurrentPage = indexOfCurrentPage
        self.defaultPageImage = scannedPages[indexOfCurrentPage].ocrOptimisedImage
    }
}

extension ImageProcessingPresenter: ImageProcessingViewPresenterProtocol {
    func setDisableBrightness() {
        scannedPages[indexOfCurrentPage].autoBrightness = false
    }
    
    func setDisableContrast() {
        scannedPages[indexOfCurrentPage].autoContrast = false
    }
    
    func getEnableBrightness() -> Bool {
        return scannedPages[indexOfCurrentPage].autoBrightness
    }
    
    func getEnableContrast() -> Bool {
        return scannedPages[indexOfCurrentPage].autoContrast
    }
    
    func setColorFilter() {
        let coloredImage = ResultPage(
            originalImage: scannedPages[indexOfCurrentPage].originalImage,
            transformedImage: nil,
            imageCorners: scannedPages[indexOfCurrentPage].imageCorners,
            autoWhiteBalance: scannedPages[indexOfCurrentPage].autoWhiteBalance,
            autoContrast: scannedPages[indexOfCurrentPage].autoContrast,
            autoBrightness: scannedPages[indexOfCurrentPage].autoBrightness,
            processingMode: scannedPages[indexOfCurrentPage].processingMode
        )
        let image = coloredImage.ocrOptimisedImage
        
        scannedPages[indexOfCurrentPage].ocrOptimisedImage = image
        defaultPageImage = image
        view?.setImage(image: image)
    }
    
    func setColorProcessingOfImage(option: DocumentScanViewEnums.ImageProccessingMode) {
        scannedPages[indexOfCurrentPage].processingMode = option
    }
    
    func getColorProcessingOfImage() -> DocumentScanViewEnums.ImageProccessingMode {
        return scannedPages[indexOfCurrentPage].processingMode
    }
    
    func setImageBrightnesAndContrast(valueBrightnes: Float, valueContrast: Float) {
        returnToDefault()
        
        guard
            let ciFilter = CIFilter(name: "CIColorControls"),
            let image = scannedPages[indexOfCurrentPage].ocrOptimisedImage,
            let ciImage = CIImage(image: image)
        else {
            return
        }
        
        ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
        ciFilter.setValue(valueBrightnes, forKey: kCIInputBrightnessKey)
        ciFilter.setValue(valueContrast, forKey: kCIInputContrastKey)

        let ciContext: CIContext = CIContext(options: nil)
        
        guard
            let outputImage = ciFilter.outputImage,
            let extend = ciFilter.outputImage?.extent,
            let cgImage = ciContext.createCGImage(outputImage, from: extend)
        else {
            return
        }
        
        view?.setImage(image: UIImage(cgImage: cgImage))
    }
    
    func applyForAllImages(brigtness: Float, contrast: Float) {
        for item in 0..<scannedPages.count {
            if item != indexOfCurrentPage {
                
                let option = scannedPages[indexOfCurrentPage].processingMode
                switch option {
                
                case .color:
                    let coloredImage = ResultPage(
                        originalImage: scannedPages[item].originalImage,
                        transformedImage: nil,
                        imageCorners: scannedPages[item].imageCorners,
                        autoWhiteBalance: scannedPages[item].autoWhiteBalance,
                        autoContrast: scannedPages[item].autoContrast,
                        autoBrightness: scannedPages[item].autoBrightness,
                        processingMode: scannedPages[item].processingMode
                    )
                    
                    scannedPages[item].ocrOptimisedImage = coloredImage.ocrOptimisedImage
                    scannedPages[item].processingMode = .color
                    
                case .blackAndWhite:
                    let image = scannedPages[item].ocrOptimisedImage
                    let autoContrastImage = OpenCVWrapper.toBlackAndWhite(image)
               
                    guard let imageNew = autoContrastImage else {
                        return
                    }
                    scannedPages[item].ocrOptimisedImage = imageNew
                    scannedPages[item].processingMode = .blackAndWhite
                    
                case .gray:
                    let image = scannedPages[item].ocrOptimisedImage
                    let autoContrastImage = OpenCVWrapper.toGray(image)
               
                    guard let imageNew = autoContrastImage else {
                        return
                    }
                    scannedPages[item].ocrOptimisedImage = imageNew
                    scannedPages[item].processingMode = .gray
                }
                
                guard
                    let ciFilter = CIFilter(name: "CIColorControls"),
                    let image = scannedPages[item].ocrOptimisedImage,
                    let ciImage = CIImage(image: image)
                else {
                    return
                }
                
                ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
                ciFilter.setValue(brigtness, forKey: kCIInputBrightnessKey)
                ciFilter.setValue(contrast, forKey: kCIInputContrastKey)
                
                let ciContext: CIContext = CIContext(options: nil)
                
                guard
                    let outputImage = ciFilter.outputImage,
                    let extend = ciFilter.outputImage?.extent,
                    let cgImage = ciContext.createCGImage(outputImage, from: extend)
                else {
                    return
                }
                
                scannedPages[item].ocrOptimisedImage = UIImage(cgImage: cgImage)
            }
        }
    }
    

    func resultPage() {
        resultDelegate?.imageProcessingPresenterDidChangePages(pages: scannedPages)
    }

    func setAutoContrast() {
        returnToDefault()
        let image = scannedPages[indexOfCurrentPage].ocrOptimisedImage
        let autoContrastImage = OpenCVWrapper.autoContrast(image)
        if let imageNew = autoContrastImage {
            view?.setImage(image: imageNew)
            scannedPages[indexOfCurrentPage].ocrOptimisedImage = imageNew
            scannedPages[indexOfCurrentPage].autoContrast = true
        }
    }
    
    func setAutoBrightness() {
        returnToDefault()
        let image = scannedPages[indexOfCurrentPage].ocrOptimisedImage
        let autoContrastImage = OpenCVWrapper.processImage(withOpenCV: image)
   
        if let imageNew = autoContrastImage {
            view?.setImage(image: imageNew)
            scannedPages[indexOfCurrentPage].ocrOptimisedImage = imageNew
            scannedPages[indexOfCurrentPage].autoBrightness = true
        }
    }
    
    func returnToDefault() {
        guard let defaultImage = self.defaultPageImage else {
            return
        }
        scannedPages[indexOfCurrentPage].ocrOptimisedImage = defaultImage
        view?.setImage(image: defaultImage)
    }
    
    func setGrayFilter() {
        returnToDefault()
        let image = scannedPages[indexOfCurrentPage].ocrOptimisedImage
        let autoContrastImage = OpenCVWrapper.toGray(image)
   
        guard let imageNew = autoContrastImage else {
            return
        }
        view?.setImage(image: imageNew)
        scannedPages[indexOfCurrentPage].ocrOptimisedImage = imageNew
        defaultPageImage = imageNew
    }
    
    func setBWFilter() {
        
        returnToDefault()
        let image = scannedPages[indexOfCurrentPage].ocrOptimisedImage
        let autoContrastImage = OpenCVWrapper.toBlackAndWhite(image)
   
        guard let imageNew = autoContrastImage else {
            return
        }
        view?.setImage(image: imageNew)
        scannedPages[indexOfCurrentPage].ocrOptimisedImage = imageNew
        defaultPageImage = imageNew
    }
    
    func setFiltredImageVersion(image: UIImage?) {
        guard let image = image else { return }
        
        scannedPages[indexOfCurrentPage].ocrOptimisedImage = image
    }
    
    func attachView(_ view: ImageProcessingViewProtocol) {
        self.view = view
        let image = scannedPages[indexOfCurrentPage].ocrOptimisedImage
        view.setImage(image: image)
        view.setControls(isAutoBrightnes: self.getEnableBrightness(), isAutoContrast: self.getEnableContrast(), typeOfColor: getColorProcessingOfImage())
    }
}

private extension ImageProcessingPresenter {
    
    // Getting color processing
    func getColorProcessing() -> DocumentScanViewEnums.ImageProccessingMode? {
        let option = documentConfig.getProcessingColorMode()
        return option
    }
}

