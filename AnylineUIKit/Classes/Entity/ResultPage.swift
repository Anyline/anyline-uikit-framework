//
//  ResultPage.swift
//  AnylineUIKit
//
//  Created by Mac on 12/14/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation
import Anyline

class ResultPage {
    var autoWhiteBalance: Bool
    var autoContrast: Bool
    var autoBrightness: Bool
    var processingMode: DocumentScanViewEnums.ImageProccessingMode
    
    private var imagePath: String?
    private var ocrOptimisedImagePath: String?
    private var imageKey: String?
    
    var thumbnail: UIImage?
    
    var imageCorners: RectangleFeature? {
        didSet {
            if let imageCorners = imageCorners {
                self.ocrOptimisedImage = self.originalImage?.correctingPerspective(with: imageCorners)
            }
        }
    }
    
    var originalImage: UIImage? {
        didSet {
            self.imageKey = ProcessInfo.processInfo.globallyUniqueString
            let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
            let cacheDirectory = paths[0]
            
            // store original image
            if let data = originalImage?.jpegData(compressionQuality: 1), let imageKey = imageKey {
                imagePath = "\(cacheDirectory)/\(imageKey).jpg"
                
                if let imagePath = imagePath, let imagePathURL = URL(string: imagePath) {
                    print(imagePath)
                    do {
                        try data.write(to: imagePathURL, options: .atomic)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    var ocrOptimisedImage: UIImage? {
        didSet {
            
            if imageKey == nil {
                self.imageKey = ProcessInfo.processInfo.globallyUniqueString
            }
            
            self.thumbnail = ocrOptimisedImage?.scaling(with: 0.25)
            let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
            let cacheDirectory = paths[0]
            
            // store corrected image
            if let data = ocrOptimisedImage?.jpegData(compressionQuality: 1), let imageKey = imageKey {
                ocrOptimisedImagePath = "\(cacheDirectory)/\(imageKey)-corrected.jpg"
                if let ocrOptimisedImagePath = ocrOptimisedImagePath, let ocrOptimisedImagePathURL = URL(string: ocrOptimisedImagePath) {
                    print(ocrOptimisedImagePath)
                    do {
                        try data.write(to: ocrOptimisedImagePathURL, options: .atomic)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }

    // MARK: - Life    
    init(originalImage: UIImage?, transformedImage: UIImage?, imageCorners: RectangleFeature?, autoWhiteBalance: Bool, autoContrast: Bool, autoBrightness: Bool, processingMode: DocumentScanViewEnums.ImageProccessingMode) {
        self.originalImage = originalImage
        self.imageCorners = imageCorners
        self.autoWhiteBalance = autoWhiteBalance
        self.autoContrast = autoContrast
        self.autoBrightness = autoBrightness
        self.processingMode = processingMode
        
        if let transformedImage = transformedImage {
            self.ocrOptimisedImage = transformedImage
        } else if let imageCorners = imageCorners {
            self.ocrOptimisedImage = originalImage?.correctingPerspective(with: imageCorners)
        } else {
            self.ocrOptimisedImage = originalImage
        }
    }
    
    func originalImagePath() -> String? {
        return self.imagePath
    }
    
    func rotatePageClockwise() {
//        self.ocrOptimisedImage = self.ocrOptimisedImage?.rotate(degrees: -90)
//        self.originalImage = self.originalImage?.rotate(degrees: -90)
        self.ocrOptimisedImage = self.ocrOptimisedImage?.rotate(clockwise: true)
        self.originalImage = self.originalImage?.rotate(clockwise: true)
        
        if let size = self.originalImage?.size {
            imageCorners?.rotateBy90(size)
//            imageCorners?.rotate(byNegative90: size)
        }
    }
    
    func rotatePageCounterClockwise() {
        self.ocrOptimisedImage = self.ocrOptimisedImage?.rotate(degrees: 90)
        self.originalImage = self.originalImage?.rotate(degrees: 90)
//        self.ocrOptimisedImage = self.ocrOptimisedImage?.rotate(clockwise: false)
//        self.originalImage = self.originalImage?.rotate(clockwise: false)
        
        if let size = self.originalImage?.size {
            imageCorners?.rotate(byNegative90: size)
        }
    }
}
