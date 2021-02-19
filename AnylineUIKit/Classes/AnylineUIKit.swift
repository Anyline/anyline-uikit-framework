//
//  AnylineUIKit.swift
//  AnylineUIKit
//
//  Created by Valentin Rep on 11.01.2021..
//  Copyright © 2021 9yards. All rights reserved.
//

import Foundation

public class AnylineUIKit {
    
    static let shared = AnylineUIKit()
    
    private (set) var licenseKey: String?
    
    private init() {}
    
    public static func setup(with licenseKey: String) {
        shared.licenseKey = licenseKey
    }
}

struct Constants {
    static let bottomPadding: CGFloat = 60
    static let safePadding: CGFloat = 20
}
