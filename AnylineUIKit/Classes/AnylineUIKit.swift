//
//  AnylineUIKit.swift
//  AnylineUIKit
//
//  Created by Valentin Rep on 11.01.2021..
//  Copyright © 2021 9yards. All rights reserved.
//

import Foundation
import Anyline

public class AnylineUIKit {
    
    static let shared = AnylineUIKit()
    
    private (set) var licenseKey: String?
    
    private init() {}
    
    public static func setup(with licenseKey: String) throws -> Bool {
        shared.licenseKey = licenseKey
        
        do {
            try AnylineSDK.setup(withLicenseKey: licenseKey)
        } catch let error {
            throw error
        }
        
        return true;
    }
}

struct Constants {
    static let bottomPadding: CGFloat = 60
    static let safePadding: CGFloat = 20
}
