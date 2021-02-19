//
//  ALResultDocument.swift
//  AnylineUIKit
//
//  Created by Mac on 12/15/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation

struct ALResultDocument {
    var nameOfSet: String
    var pages: [ResultPage]
    
    init(pages: [ResultPage]) {
        self.pages = pages
        
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yy-MM-dd hh:mm"
        
        let result = formatter.string(from: date)
        
        nameOfSet = "Scan " + result
    }
}
