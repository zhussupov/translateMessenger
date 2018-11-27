//
//  UITextFieldExtension.swift
//  Translate Messenger
//
//  Created by zhussupov on 11/24/18.
//  Copyright © 2018 Zhussupov. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func setupAccessoryInput() {
        let toolbar = UIToolbar(frame: CGRect.init(x: 0.0, y: 0.0, width: self.frame.width, height: 44.0))
        let dismissButton = UIBarButtonItem(image: #imageLiteral(resourceName: "chevron_down"), style: .plain, target: self, action: #selector(hideKeyboard))
        dismissButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black], for: .normal)
        dismissButton.tintColor = Colors.themeColorBlue
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [flexSpace, dismissButton]
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        toolbar.addGestureRecognizer(tapGestureRecognizer)
        
        self.inputAccessoryView = toolbar
    }
    
    @objc func hideKeyboard() {
        self.resignFirstResponder()
    }
}
