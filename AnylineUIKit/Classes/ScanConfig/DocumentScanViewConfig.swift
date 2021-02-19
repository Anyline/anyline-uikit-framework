//
//  ScanConfig.swift
//  AnylineUIKit
//
//  Created by Mac on 10/27/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation
import Anyline

public class DocumentScanViewConfig {
    
    // MARK: - OTHER CONSTANTS

    private static let toleranceMin: Double = 0.05   // the minimal allowed tolerance for predefined scan formats that can be set in the json parameter file.
    private static let toleranceMax: Double = 0.3
    
    // MARK: - MODES USED AT LAST
    private var flashMode: ALFlashStatus = .auto
    private var scanMode: DocumentScanViewEnums.ScanMode = .singlePage
    
    // MARK: - WHITE BALANCE

    private var enablePostProcessing: Bool = false
    
    // MARK: - REDUCE PICTURE SIZE DIALOG
    
    private var reducePictureSizeMaxSizeSmall: Int = 854
    private var reducePictureSizeMaxSizeMedium: Int = 1366
    private var reducePictureSizeMaxSizeLarge: Int = 1920
    private var reducePictureSizeMaxSizeCustom: Int = 1024
    private var reducePictureSizeAllowChangeCustomSize: Bool = true
    private var reducePictureSizeOption: DocumentScanViewEnums.ReduceSizeOption = .noReduceSize
    
    // MARK: - SCAN FORMATS PASSED TO THE SCANNING ENGINE
    
    private var selectScanFormat: DocumentScanViewEnums.SelectScanFormat = .all // all portrait formats / only predefined formats + custom format
    private var allFormatsMaxRatioWidth: Int = 1     // max ratio will be a square (format 1:1)
    private var allFormatsMaxRatioHeight: Int = 1
    private var allFormatsMinRatioWidth: Int = 1     // min ratio will be a slim rectangle (1:6)
    private var allFormatsMinRatioHeight: Int = 6
    private var formatTolerance: Double = 0.1    // tolerance for predefined scan formats
    private var scanFormat: [Bool] = []     // predefined scan format ratios: a4, ComplimentarySlip, BusinessCard, Letter, CustomRatio
    private var customRatioValueShortSide: Int = 2
    private var customRatioValueLongSide: Int = 3
    
    // MARK: - CONTROLS ON BOTTOM BAR
    
    private static let numberBottomBarControls: Int = 5   // maximum number of controls on the always-visible horizontal part of the bottom bar
    private static let numberBottomBarExtensionControls: Int = 4 // maximum number or controls on the expandible part of the bottom bar, vertical layout
    
    private static let numberBottomGalleryBarControls: Int = 5   // maximum number of controls on the always-visible horizontal part of the bottom gallery bar
    private static let numberBottomGalleryBarExtensionControls: Int = 4 // maximum number or controls on the expandible part of the gallery bottom bar, vertical layout

    private var bottomBarControl: [DocumentScanViewEnums.BottomBarControl] = []  // these are controls placed on the horizontal fixed part of the bottom bar
    private var bottomBarWidth: [Int] = []   // the width of a layout in relation to other layout-widths
    private var bottomBarExtensionControl: [DocumentScanViewEnums.BottomBarControl] = []  // these are controls placed on the dynamic part of the bottom bar, user will have to pull it up
    
    private var bottomGalleryBarControl: [DocumentScanViewEnums.BottomGalleryBarControl] = []  // these are controls placed on the horizontal fixed part of the bottom bar
    private var bottomGalleryBarExtensionControl: [DocumentScanViewEnums.BottomGalleryBarControl] = []  // these are controls placed on the dynamic part of the bottom bar, user will have to pull it up
    
    
    // MARK: - CONTROLS ON BOTTOM BAR OF CROP VIEW
    
    private var showCancelOnCropView: Bool = false  // the bottom bar of the crop view has always an ok-button. a cancel button is optional
    
    // MARK: COLORS
    
    private var tintControls: UIColor = UIColor.init(hexString: "#007acc")
    private var tintControlsDisabled: UIColor = UIColor.init(hexString: "#bbbbbb")
    private var tintManualPictureButton: UIColor = UIColor.init(hexString: "#009999")
    private var textMessage: UIColor = UIColor.init(hexString: "#111111")
    private var backgroundMessage: UIColor = UIColor.init(hexString: "#fff399")
    private var textHint: UIColor = UIColor.init(hexString: "#111111")
    private var backgroundHint: UIColor = UIColor.init(hexString: "#fff399")
    private var textBottomBar: UIColor = UIColor.init(hexString: "#007acc")
    private var backgroundBottomBar: UIColor = UIColor.init(hexString: "#efefef")
    private var divider: UIColor = UIColor.init(hexString: "#999999")
    
    // MARK: IMAGE PROCESSING
    
    private var autoWhiteBalance: Bool = false
    private var autoContrast: Bool = false
    private var autoBrightness: Bool = false
    
    private var processingColor: DocumentScanViewEnums.ImageProccessingMode = .color
    
    private let jsonFilePath: String
    private var documentConfigJson: DocumentConfig?

    public init(jsonFilePath: String) {
        self.jsonFilePath = jsonFilePath
        let documentConfig = loadJson(jsonFilePath: jsonFilePath)
        self.documentConfigJson = documentConfig
        
        scanFormat = Array(repeating: false, count: DocumentScanViewEnums.ScanRatio.allCases.count)
        
        
        bottomBarWidth = Array(repeating: 1, count: DocumentScanViewConfig.numberBottomBarControls)
        bottomBarControl = Array(repeating: .empty, count: DocumentScanViewConfig.numberBottomBarControls)
        bottomBarControl[0] = .cancel
        bottomBarControl[1] = .manualPicture
        bottomBarControl[2] = .ok
        bottomBarControl[3] = .flash
        bottomBarControl[4] = .scanMode
        
        bottomBarExtensionControl = Array(repeating: .empty, count: DocumentScanViewConfig.numberBottomBarExtensionControls)
        bottomBarExtensionControl[0] = .pictureResize
        bottomBarExtensionControl[1] = .format
        
        bottomGalleryBarControl = Array(repeating: .empty, count: DocumentScanViewConfig.numberBottomGalleryBarControls)
        bottomGalleryBarControl[0] = .delete
        bottomGalleryBarControl[1] = .rotateLeft
        bottomGalleryBarControl[2] = .rotateRight
        bottomGalleryBarControl[3] = .crop
        bottomGalleryBarControl[4] = .newScan
        
        bottomGalleryBarExtensionControl = Array(repeating: .empty, count: DocumentScanViewConfig.numberBottomGalleryBarExtensionControls)
        bottomGalleryBarExtensionControl[0] = .rearrange
        bottomGalleryBarExtensionControl[1] = .importImage
        bottomGalleryBarExtensionControl[2] = .processing
        bottomGalleryBarExtensionControl[3] = .empty
        
        guard let documentConfigJson = self.documentConfigJson else {
            return
        }
        
        if let scanMode = documentConfigJson.scanMode, let enumScanMode = DocumentScanViewEnums.ScanMode.getScanModeFromString(scanMode: scanMode) {
            self.scanMode = enumScanMode
        }
        
        if let enablePostProcessing = documentConfigJson.enablePostProcessing {
            self.enablePostProcessing = enablePostProcessing
        }
        
        if let showCancelOnCropView = documentConfigJson.showCancelOnCropView {
            self.showCancelOnCropView = showCancelOnCropView
        }
        initReducePictureSize(documentConfigJson: documentConfigJson)
        initBottomBar(documentConfigJson: documentConfigJson)
        initBottomBarExtension(documentConfigJson: documentConfigJson)
        initBottomGalleryBar(documentConfigJson: documentConfigJson)
        initBottomGalleryBarExtension(documentConfigJson: documentConfigJson)
        initScanFormat(documentConfigJson: documentConfigJson)
        initColors(documentConfigJson: documentConfigJson)
        initImageProcessing(documentConfigJson: documentConfigJson)
    }
    
    private func initReducePictureSize(documentConfigJson: DocumentConfig) {
        guard let pictureSize = documentConfigJson.reducePictureSize else {
            return
        }
        
        if let allowChangeCustomSize = pictureSize.allowChangeCustomSize {
            self.reducePictureSizeAllowChangeCustomSize = allowChangeCustomSize
        }
        
        if let pictureSizeOption = pictureSize.option, let reducePictureSizeOption = DocumentScanViewEnums.ReduceSizeOption.getReduceSizeOptionFromString(reduceSize: pictureSizeOption) {
            self.reducePictureSizeOption = reducePictureSizeOption
        }
        
        if let maxSizeSmall = pictureSize.maxSizeSmall {
            self.reducePictureSizeMaxSizeSmall = maxSizeSmall
        }
        
        if let maxSizeMedium = pictureSize.maxSizeMedium {
            self.reducePictureSizeMaxSizeMedium = maxSizeMedium
        }
        
        if let maxSizeLarge = pictureSize.maxSizeLarge {
            self.reducePictureSizeMaxSizeLarge = maxSizeLarge
        }
        
        if let maxSizeCustom = pictureSize.maxSizeCustom {
            self.reducePictureSizeMaxSizeCustom = maxSizeCustom
        }
    }
    
    private func initScanFormat(documentConfigJson: DocumentConfig) {
        guard let scanFormat = documentConfigJson.scanFormat else {
            return
        }

        if let tolerance = scanFormat.formatTolerance, let doubleTolerance = Double(tolerance) {
            self.formatTolerance = doubleTolerance
        }

        if let scanFormat = scanFormat.selectFormats, let selectScanFormat = DocumentScanViewEnums.SelectScanFormat.getScanFormatFromString(scanFormat: scanFormat) {
            self.selectScanFormat = selectScanFormat
        }
        
        if let scanFormatA4 = scanFormat.a4, let indexScanFormatA4 = DocumentScanViewEnums.ScanRatio.getScanRatioFromString(scanRatio: DocumentScanViewEnums.enumScanRatioA4) {
            self.scanFormat[indexScanFormatA4.rawValue] = scanFormatA4
        }
        
        if let scanFormatComplimentSlip = scanFormat.complimentSlip, let indexScanFormatComplimentSlip = DocumentScanViewEnums.ScanRatio.getScanRatioFromString(scanRatio: DocumentScanViewEnums.enumScanRatioComplimentSlip) {
            self.scanFormat[indexScanFormatComplimentSlip.rawValue] = scanFormatComplimentSlip
        }
        
        if let scanFormatBusinessCard = scanFormat.businessCard, let indexScanFormatBusinessCard = DocumentScanViewEnums.ScanRatio.getScanRatioFromString(scanRatio: DocumentScanViewEnums.enumScanRatioBusinessCard) {
            self.scanFormat[indexScanFormatBusinessCard.rawValue] = scanFormatBusinessCard
        }
        
        if let scanFormatLetter = scanFormat.letter, let indexScanFormatLetter = DocumentScanViewEnums.ScanRatio.getScanRatioFromString(scanRatio: DocumentScanViewEnums.enumScanRatioLetter) {
            self.scanFormat[indexScanFormatLetter.rawValue] = scanFormatLetter
        }
        
        if let scanFormatCustomRatio = scanFormat.customRatio, let indexScanFormatCustomRatio = DocumentScanViewEnums.ScanRatio.getScanRatioFromString(scanRatio: DocumentScanViewEnums.enumScanRatioCustomRatio) {
            self.scanFormat[indexScanFormatCustomRatio.rawValue] = scanFormatCustomRatio
        }
        
        if let shortSide = scanFormat.customRatioValueShortSide {
            self.customRatioValueShortSide = shortSide
        }
        
        if let longSide = scanFormat.customRatioValueLongSide {
            self.customRatioValueLongSide = longSide
        }
        
        if let joScanFormatMaxRatio = scanFormat.allformatsmaxratio {
            if let width = joScanFormatMaxRatio.width, let height = joScanFormatMaxRatio.height {
                self.allFormatsMaxRatioWidth = width
                self.allFormatsMaxRatioHeight = height
            }
        }
        
        if let joScanFormatMinRatio = scanFormat.allformatsminratio {
            if let width = joScanFormatMinRatio.width, let height = joScanFormatMinRatio.height {
                self.allFormatsMinRatioWidth = width
                self.allFormatsMinRatioHeight = height
            }
        }
    }
    
    private func initBottomBar(documentConfigJson: DocumentConfig) {
        if let bottomBar = documentConfigJson.bottomBar {
            if let position0 = bottomBar.position0, let width = position0.width, let joControl = position0.control, let control = DocumentScanViewEnums.BottomBarControl.getBottomBarControllFromString(bottomBarControl: joControl) {
                self.bottomBarControl[0] = control
                self.bottomBarWidth[0] = width
            }
            if let position1 = bottomBar.position1, let width = position1.width, let joControl = position1.control, let control = DocumentScanViewEnums.BottomBarControl.getBottomBarControllFromString(bottomBarControl: joControl) {
                self.bottomBarControl[1] = control
                self.bottomBarWidth[1] = width
            }
            if let position2 = bottomBar.position2, let width = position2.width, let joControl = position2.control, let control = DocumentScanViewEnums.BottomBarControl.getBottomBarControllFromString(bottomBarControl: joControl) {
                self.bottomBarControl[2] = control
                self.bottomBarWidth[2] = width
            }
            if let position3 = bottomBar.position3, let width = position3.width, let joControl = position3.control, let control = DocumentScanViewEnums.BottomBarControl.getBottomBarControllFromString(bottomBarControl: joControl) {
                self.bottomBarControl[3] = control
                self.bottomBarWidth[3] = width
            }
            if let position4 = bottomBar.position4, let width = position4.width, let joControl = position4.control, let control = DocumentScanViewEnums.BottomBarControl.getBottomBarControllFromString(bottomBarControl: joControl) {
                self.bottomBarControl[4] = control
                self.bottomBarWidth[4] = width
            }
        }
    }
    
    private func initBottomBarExtension(documentConfigJson: DocumentConfig) {
        if let bottomBar = documentConfigJson.bottomBarExtension {
            if let line0 = bottomBar.line0, let control = DocumentScanViewEnums.BottomBarControl.getBottomBarControllFromString(bottomBarControl: line0) {
                bottomBarExtensionControl[0] = control
            }
            if let line1 = bottomBar.line1, let control = DocumentScanViewEnums.BottomBarControl.getBottomBarControllFromString(bottomBarControl: line1) {
                bottomBarExtensionControl[1] = control
            }
            if let line2 = bottomBar.line2, let control = DocumentScanViewEnums.BottomBarControl.getBottomBarControllFromString(bottomBarControl: line2) {
                bottomBarExtensionControl[2] = control
            }
            if let line3 = bottomBar.line3, let control = DocumentScanViewEnums.BottomBarControl.getBottomBarControllFromString(bottomBarControl: line3) {
                bottomBarExtensionControl[3] = control
            }
        }
    }
    
    private func initBottomGalleryBar(documentConfigJson: DocumentConfig) {
        if let bottomBar = documentConfigJson.bottomGalleryBar {
            if let position0 = bottomBar.position0, let joControl = position0.control, let control = DocumentScanViewEnums.BottomGalleryBarControl.getBottomGalleryBarControllFromString(bottomGalleryBarControl: joControl) {
                self.bottomGalleryBarControl[0] = control
            }
            if let position1 = bottomBar.position1, let joControl = position1.control, let control = DocumentScanViewEnums.BottomGalleryBarControl.getBottomGalleryBarControllFromString(bottomGalleryBarControl: joControl) {
                self.bottomGalleryBarControl[1] = control
            }
            if let position2 = bottomBar.position2, let joControl = position2.control, let control = DocumentScanViewEnums.BottomGalleryBarControl.getBottomGalleryBarControllFromString(bottomGalleryBarControl: joControl) {
                self.bottomGalleryBarControl[2] = control
            }
            if let position3 = bottomBar.position3, let joControl = position3.control, let control = DocumentScanViewEnums.BottomGalleryBarControl.getBottomGalleryBarControllFromString(bottomGalleryBarControl: joControl) {
                self.bottomGalleryBarControl[3] = control
            }
            if let position4 = bottomBar.position4, let joControl = position4.control, let control = DocumentScanViewEnums.BottomGalleryBarControl.getBottomGalleryBarControllFromString(bottomGalleryBarControl: joControl) {
                self.bottomGalleryBarControl[4] = control
            }
        }
    }
    
    private func initBottomGalleryBarExtension(documentConfigJson: DocumentConfig) {
        if let bottomBar = documentConfigJson.bottomGalleryBarExtension {
            if let line0 = bottomBar.line0, let control = DocumentScanViewEnums.BottomGalleryBarControl.getBottomGalleryBarControllFromString(bottomGalleryBarControl: line0) {
                bottomGalleryBarExtensionControl[0] = control
            }
            if let line1 = bottomBar.line1, let control = DocumentScanViewEnums.BottomGalleryBarControl.getBottomGalleryBarControllFromString(bottomGalleryBarControl: line1) {
                bottomGalleryBarExtensionControl[1] = control
            }
            if let line2 = bottomBar.line2, let control = DocumentScanViewEnums.BottomGalleryBarControl.getBottomGalleryBarControllFromString(bottomGalleryBarControl: line2) {
                bottomGalleryBarExtensionControl[2] = control
            }
            if let line3 = bottomBar.line3, let control = DocumentScanViewEnums.BottomGalleryBarControl.getBottomGalleryBarControllFromString(bottomGalleryBarControl: line3) {
                bottomGalleryBarExtensionControl[3] = control
            }
        }
    }
    
    private func initColors(documentConfigJson: DocumentConfig) {
        if let colors = documentConfigJson.colors {
            if let joTintControls = colors.tintControls {
                tintControls = UIColor.init(hexString: getHexFromJsonColor(colorString: joTintControls))
            }

            if let joTintControlsDisabled = colors.tintControlsDisabled {
                tintControlsDisabled = UIColor(hexString: getHexFromJsonColor(colorString: joTintControlsDisabled))
            }

            if let joBackgroundBottomBar = colors.backgroundBottomBar {
                backgroundBottomBar = UIColor(hexString: getHexFromJsonColor(colorString: joBackgroundBottomBar))
            }

            if let joBackgroundHint = colors.backgroundHint {
                backgroundHint = UIColor(hexString: getHexFromJsonColor(colorString: joBackgroundHint))
            }

            if let joBackgroundMessage = colors.backgroundMessage {
                backgroundMessage = UIColor(hexString: getHexFromJsonColor(colorString: joBackgroundMessage))
            }
            
            if let joDivider = colors.divider {
                divider = UIColor(hexString: getHexFromJsonColor(colorString: joDivider))
            }

            if let joTextBottomBar = colors.textBottomBar {
                textBottomBar = UIColor(hexString: getHexFromJsonColor(colorString: joTextBottomBar))
            }

            if let joTextHint = colors.textHint {
                textHint = UIColor(hexString: getHexFromJsonColor(colorString: joTextHint))
            }

            if let joTintManualPictureButton = colors.tintManualPictureButton {
                tintManualPictureButton = UIColor(hexString: getHexFromJsonColor(colorString: joTintManualPictureButton))
            }

            if let joTextMessage = colors.textMessage {
                textMessage = UIColor(hexString: getHexFromJsonColor(colorString: joTextMessage))
            }
        }
    }
    
    private func initImageProcessing(documentConfigJson: DocumentConfig) {
        if let imageProcessing = documentConfigJson.imageProcessing {
            if let joAutoWB = imageProcessing.autoWhiteBalance {
                autoWhiteBalance = joAutoWB
            }
            if let joAutoContrast = imageProcessing.autoContrast {
                autoContrast = joAutoContrast
            }
            if let joAutoBrightnes = imageProcessing.autoBrightness {
                autoBrightness = joAutoBrightnes
            }
            if let joColor = imageProcessing.imageTypeConversion, let mode = DocumentScanViewEnums.ImageProccessingMode.getScanRatioFromString(imageProcessing: joColor) {
                processingColor = mode
            }
        }
    }
    
    private func loadJson(jsonFilePath: String) -> DocumentConfig? {
        let url = URL(fileURLWithPath: jsonFilePath)
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let documentConfig = try decoder.decode(DocumentConfig.self, from: data)
            return documentConfig
        } catch {
            print("error:\(error)")
            return nil
        }
    }
    
    private func getHexFromJsonColor(colorString: String) -> String {
        return "#" + colorString
    }
    
    
//MARK:  - S E T T E R ,  S E T T E R

    
     // P I C T U R E   S I Z E
    
    
    public func getReducePictureSizeOption() -> DocumentScanViewEnums.ReduceSizeOption {
        return reducePictureSizeOption
    }
    
    public func setReducePictureSizeOption(option: DocumentScanViewEnums.ReduceSizeOption) {
        self.reducePictureSizeOption = option
    }

    public func getReducePictureSizeMaxSizeSmall() -> Int {
        return reducePictureSizeMaxSizeCustom
    }
    
    public func setReducePictureSizeMaxSizeSmall(size: Int) {
        self.reducePictureSizeMaxSizeSmall = size
    }
    
    public func getReducePictureSizeMaxSizeMedium() -> Int {
        return reducePictureSizeMaxSizeMedium
    }

    public func setReducePictureSizeMaxSizeMedium(size: Int) {
        self.reducePictureSizeMaxSizeMedium = size
    }

    public func getReducePictureSizeMaxSizeLarge() -> Int {
        return reducePictureSizeMaxSizeLarge
    }

    public func setReducePictureSizeMaxSizeLarge(size: Int) {
        self.reducePictureSizeMaxSizeLarge = size
    }

    public func getReducePictureSizeMaxSizeCustom() -> Int {
        return reducePictureSizeMaxSizeCustom
    }

    public func setReducePictureSizeMaxSizeCustom(size: Int) {
        self.reducePictureSizeMaxSizeCustom = size
    }

    public func getReducePictureSizeAllowChangeCustomSize() -> Bool {
        return reducePictureSizeAllowChangeCustomSize
    }

    public func setReducePictureSizeAllowChangeCustomSize(allowChangeCustomSize: Bool) {
        self.reducePictureSizeAllowChangeCustomSize = allowChangeCustomSize
    }

     // D O C U M E N T   F O R M A T

    public func getSelectScanFormat() -> DocumentScanViewEnums.SelectScanFormat {
        return selectScanFormat
    }

    public func setSelectScanFormat(selectScanFormat: DocumentScanViewEnums.SelectScanFormat) {
        self.selectScanFormat = selectScanFormat
    }

    public func getScanFormat(scanRatio: DocumentScanViewEnums.ScanRatio) -> Bool {
        return scanFormat[scanRatio.rawValue]
    }

    public func setScanFormat(scanRatio: DocumentScanViewEnums.ScanRatio, scanFormat: Bool) {
        self.scanFormat[scanRatio.rawValue] = scanFormat
    }


    public func getFormatTolerance() -> Double {
        return formatTolerance
    }

    public func setFormatTolerance(value: Double) {
        // TODO VALIDDATION
    }


    public func getAllFormatsMaxRatioWidth() -> Int {
        return allFormatsMaxRatioWidth
    }

    public func setAllFormatsMaxRatioWidth(value: Int) {
        self.allFormatsMaxRatioWidth = value
    }


    public func getAllFormatsMaxRatioHeight() -> Int {
        return allFormatsMaxRatioHeight
    }

    public func setAllFormatsMaxRatioHeight(value: Int) {
        self.allFormatsMaxRatioHeight = value
    }

    public func getAllFormatsMinRatioWidth() -> Int {
        return allFormatsMinRatioWidth
    }

    public func setAllFormatsMinRatioWidth(value: Int) {
        self.allFormatsMinRatioWidth = value
    }

    public func getAllFormatsMinRatioHeight() -> Int {
        return allFormatsMinRatioHeight
    }

    public func setAllFormatsMinRatioHeight(value: Int) {
        self.allFormatsMinRatioHeight = value
    }

    public func getCustomRatioValueShortSide() -> Int {
        return customRatioValueShortSide
    }

    public func setCustomRatioValueShortSide(value: Int) {
        self.customRatioValueShortSide = value
    }

    public func getCustomRatioValueLongSide() -> Int {
        return customRatioValueLongSide
    }

    public func setCustomRatioValueLongSide(value: Int) {
        self.customRatioValueLongSide = value
    }

    // L A Y O U T   B O T T O M   B A R

    public func getScanBottomBar() -> [DocumentScanViewEnums.BottomBarControl] {
        return bottomBarControl
    }

    public func getScanExtensionBottomBar() -> [DocumentScanViewEnums.BottomBarControl] {
        return bottomBarExtensionControl
    }
    
    public func getScanBottomGalleryBar() -> [DocumentScanViewEnums.BottomGalleryBarControl] {
        return bottomGalleryBarControl
    }

    public func getScanExtensionBottomGalleryBar() -> [DocumentScanViewEnums.BottomGalleryBarControl] {
        return bottomGalleryBarExtensionControl
    }

    // S C A N   M O D E

    public func getScanMode() -> DocumentScanViewEnums.ScanMode {
        return scanMode
    }

    public func setScanMode(scanMode: DocumentScanViewEnums.ScanMode) {
        print("set aaa -> ", scanMode)
        self.scanMode = scanMode
    }
   
    // P O S T   P R O C E S S I N G


    public func getPostProcessing() -> Bool {
        return enablePostProcessing
    }

    public func setPostProcessing(enablePostProcessing: Bool) {
        self.enablePostProcessing = enablePostProcessing;
    }
    
    // F L A S H  M O D E
    
    public func getFlashMode() -> ALFlashStatus {
        return flashMode
    }
    
    public func setFlashMode(status: ALFlashStatus) {
        self.flashMode = status
    }
    
    // C O L O R S
    
    public func getBackgroundBottomBar() -> UIColor {
        return self.backgroundBottomBar
    }
    
    public func getBackgroundHint() -> UIColor {
        return self.backgroundHint
    }
    
    public func getBackgroundMessager() -> UIColor {
        return self.backgroundMessage
    }
    
    public func getDivider() -> UIColor {
        return self.divider
    }
    
    public func getTextBottomBar() -> UIColor {
        return self.textBottomBar
    }
    
    public func getTextHint() -> UIColor {
        return self.textHint
    }
    
    public func getTextMessage() -> UIColor {
        return self.textMessage
    }
    
    public func getTintControls() -> UIColor {
        return self.tintControls
    }
    
    public func getTintControlsDisabled() -> UIColor {
        return self.tintControlsDisabled
    }
    
    public func getTintManualPictureButton() -> UIColor {
        return self.tintManualPictureButton
    }
    
    // I M A G E  P R O C E S S I N G

    public func getAutoWhiteBalance() -> Bool {
        return self.autoWhiteBalance
    }
    
    public func getAutoBrightness() -> Bool {
        return self.autoBrightness
    }
    
    public func getAutoContrast() -> Bool {
        return self.autoContrast
    }
    
    public func getProcessingColorMode() -> DocumentScanViewEnums.ImageProccessingMode {
        return self.processingColor
    }
}
