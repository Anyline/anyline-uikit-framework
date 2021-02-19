//
//  UIViewController+Extension.swift
//  AnylineUIKit
//
//  Created by Mac on 11/6/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import UIKit

extension UIViewController {
    func setupDismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}

protocol Alertable {
    func showAlert(message: String)
}

extension Alertable where Self: UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
