//
//  Optional+Extension.swift
//  AnylineUIKit
//
//  Created by Valentin Rep on 03.02.2021..
//  Copyright © 2021 9yards. All rights reserved.
//

import Foundation

extension Optional where Wrapped == UIViewPropertyAnimator
{
    @discardableResult
    func addCompletion(_ block: @escaping (UIViewAnimatingPosition)->()) -> Optional<UIViewPropertyAnimator> {
        if let animator = self {
            animator.addCompletion(block)
        } else {
            block(.end)
        }
        
        return self
    }
}
