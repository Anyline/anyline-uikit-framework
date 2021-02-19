//
//  String+Extension.swift
//  AnylineUIKit
//
//  Created by Mac on 10/23/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation

extension String {

    func localized(bundle: Bundle) -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: bundle, value: "??\(self)??", comment: "")
    }
}
