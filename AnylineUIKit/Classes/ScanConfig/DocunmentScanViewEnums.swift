//
//  DocunmentScanViewEnums.swift
//  AnylineUIKit
//
//  Created by Mac on 10/28/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation

public class DocumentScanViewEnums {

    public static let enumScanModeSinglePage = "single_page"
    public static let enumScanModeMultiplePage = "multiple_pages"

    public static let enumReducePictureSizeOptionNoReduceSize = "no_reduce_size"
    public static let enumReducePictureSizeOptionSmall = "small"
    public static let enumReducePictureSizeOptionMedium = "medium"
    public static let enumReducePictureSizeOptionLarge = "large"
    public static let enumReducePictureSizeOptionCustom = "custom"

    public static let enumSelectScanFormatAll = "all"
    public static let enumSelectScanFormatPredefined = "predefined"

    public static let enumBottomBarControlFlash = "flash"
    public static let enumBottomBarControlScanMode = "scan_mode"
    public static let enumBottomBarControlManualPicture = "manual_picture"
    public static let enumBottomBarControlCancel = "cancel"
    public static let enumBottomBarControlOk = "ok"
    public static let enumBottomBarControlFormat = "format"
    public static let enumBottomBarControlPictureResize = "picture_resize"
    public static let enumBottomBarControlEmpty = "empty"
    
    public static let enumBottomGalleryBarControlDelete = "delete_picture"
    public static let enumBottomGalleryBarControlRotateLeft = "rotate_left_picture"
    public static let enumBottomGalleryBarControlRotateRight = "rotate_right_picture"
    public static let enumBottomGalleryBarControlCrop = "crop_image"
    public static let enumBottomGalleryBarControlNewScan = "new_scan"
    public static let enumBottomGalleryBarControlRearrange = "rearrange_image"
    public static let enumBottomGalleryBarControlImport = "import_image"
    public static let enumBottomGalleryBarControlProcessing = "processing_image"

    public static let enumScanRatioA4 = "A4"
    public static let enumScanRatioComplimentSlip = "ComplimentSlip"
    public static let enumScanRatioBusinessCard = "BusinessCard"
    public static let enumScanRatioLetter = "Letter"
    public static let enumScanRatioCustomRatio = "CustomRatio"

    public static let enumColorProcessing = "color"
    public static let enumBWProcessing = "bw"
    public static let enumGrayProcessing = "gray"

    public enum ScanMode: Int, CaseIterable {
        case singlePage = 0
        case multiplePages
        
        public static func getScanModeFromInt(scanMode: Int) -> ScanMode? {
            switch scanMode {
            case 0:
                return .singlePage
            case 1:
                return .multiplePages
            default:
                return nil
            }
        }
        
        public static func getScanModeFromString(scanMode: String) -> ScanMode? {
            switch scanMode {
            case enumScanModeSinglePage:
                return .singlePage
            case enumScanModeMultiplePage:
                return .multiplePages
            default:
                return nil
            }
        }
    }
    
    public enum ReduceSizeOption: Int, CaseIterable {
        case noReduceSize = 0
        case small
        case medium
        case large
        case custom
        
        public static func getReduceSizeOptionFromInt(reduceSize: Int) -> ReduceSizeOption? {
            switch reduceSize {
            case 0:
                return .noReduceSize
            case 1:
                return .small
            case 2:
                return .medium
            case 3:
                return .large
            case 4:
                return .custom
            default:
                return nil
            }
        }
        
        public static func getReduceSizeOptionFromString(reduceSize: String) -> ReduceSizeOption? {
            switch reduceSize {
            case enumReducePictureSizeOptionNoReduceSize:
                return .noReduceSize
            case enumReducePictureSizeOptionSmall:
                return .small
            case enumReducePictureSizeOptionMedium:
                return .medium
            case enumReducePictureSizeOptionLarge:
                return .large
            case enumReducePictureSizeOptionCustom:
                return .custom
            default:
                return nil
            }
        }
    }
    
    public enum SelectScanFormat: Int, CaseIterable {
        case all = 0
        case predefined
        
        public static func getScanFormatFromInt(scanFormat: Int) -> SelectScanFormat? {
            switch scanFormat {
            case 0:
                return .all
            case 1:
                return .predefined
            default:
                return nil
            }
        }
        
        public static func getScanFormatFromString(scanFormat: String) -> SelectScanFormat? {
            switch scanFormat {
            case enumSelectScanFormatAll:
                return .all
            case enumSelectScanFormatPredefined:
                return .predefined
            default:
                return nil
            }
        }
    }
    
    public enum BottomBarControl: Int, CaseIterable {
        case flash = 0
        case scanMode
        case manualPicture
        case cancel
        case ok
        case format
        case pictureResize
        case empty
        
        public static func getBottomBarControlFromInt(bottomBarControl: Int) -> BottomBarControl? {
            switch bottomBarControl {
            case 0:
                return .flash
            case 1:
                return .scanMode
            case 2:
                return .manualPicture
            case 3:
                return .cancel
            case 4:
                return .ok
            case 5:
                return .format
            case 6:
                return .pictureResize
            case 7:
                return .empty
            default:
                return nil
            }
        }
        
        public static func getBottomBarControllFromString(bottomBarControl: String) -> BottomBarControl? {
            switch bottomBarControl {
            case enumBottomBarControlFlash:
                return .flash
            case enumBottomBarControlScanMode:
                return .scanMode
            case enumBottomBarControlManualPicture:
                return .manualPicture
            case enumBottomBarControlCancel:
                return .cancel
            case enumBottomBarControlOk:
                return .ok
            case enumBottomBarControlFormat:
                return .format
            case enumBottomBarControlPictureResize:
                return .pictureResize
            case enumBottomBarControlEmpty:
                return .empty
            default:
                return nil
            }
        }
    }
    
    public enum BottomGalleryBarControl: Int, CaseIterable {
        case delete = 0
        case rotateLeft
        case rotateRight
        case crop
        case newScan
        case rearrange
        case importImage
        case processing
        case empty
        
        public static func getBottomGalleryBarControlFromInt(bottomGalleryBarControl: Int) -> BottomGalleryBarControl? {
            switch bottomGalleryBarControl {
            case 0:
                return .delete
            case 1:
                return .rotateLeft
            case 2:
                return .rotateRight
            case 3:
                return .crop
            case 4:
                return .newScan
            case 5:
                return .rearrange
            case 6:
                return .importImage
            case 7:
                return .processing
            case 8:
                return .empty
            default:
                return nil
            }
        }
        
        public static func getBottomGalleryBarControllFromString(bottomGalleryBarControl: String) -> BottomGalleryBarControl? {
            switch bottomGalleryBarControl {
            case enumBottomGalleryBarControlDelete:
                return .delete
            case enumBottomGalleryBarControlRotateLeft:
                return .rotateLeft
            case enumBottomGalleryBarControlRotateRight:
                return .rotateRight
            case enumBottomGalleryBarControlCrop:
                return .crop
            case enumBottomGalleryBarControlNewScan:
                return .newScan
            case enumBottomGalleryBarControlRearrange:
                return .rearrange
            case enumBottomGalleryBarControlImport:
                return .importImage
            case enumBottomGalleryBarControlProcessing:
                return .processing
            case enumBottomBarControlEmpty:
                return .empty
            default:
                return nil
            }
        }
    }
    
    public enum ScanRatio: Int, CaseIterable {
        case a4 = 0
        case complimentSlip
        case businessCard
        case letter
        case customRatio
        
        public static func getScanRatioFromInt(scanRatio: Int) -> ScanRatio? {
            switch scanRatio {
            case 0:
                return .a4
            case 1:
                return .complimentSlip
            case 2:
                return .businessCard
            case 3:
                return .letter
            case 4:
                return .customRatio
            default:
                return nil
            }
        }
        
        public static func getScanRatioFromString(scanRatio: String) -> ScanRatio? {
            switch scanRatio {
            case enumScanRatioA4:
                return .a4
            case enumScanRatioComplimentSlip:
                return .complimentSlip
            case enumScanRatioBusinessCard:
                return .businessCard
            case enumScanRatioLetter:
                return .letter
            case enumScanRatioCustomRatio:
                return .customRatio
            default:
                return nil
            }
        }
    }
    
    public enum ImageProccessingMode: Int, CaseIterable {
        case color = 0
        case blackAndWhite
        case gray
        
        public static func getImageProcessingFromInt(imageProcessing: Int) -> ImageProccessingMode? {
            switch imageProcessing {
            case 0:
                return .color
            case 1:
                return .blackAndWhite
            case 2:
                return .gray
            default:
                return nil
            }
        }
        
        public static func getScanRatioFromString(imageProcessing: String) -> ImageProccessingMode? {
            switch imageProcessing {
            case enumColorProcessing:
                return .color
            case enumBWProcessing:
                return .blackAndWhite
            case enumGrayProcessing:
                return .gray
            default:
                return nil
            }
        }
    }
}
