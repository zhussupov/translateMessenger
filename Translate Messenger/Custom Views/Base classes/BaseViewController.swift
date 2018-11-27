//
//  BaseViewController.swift
//  Translate Messenger
//
//  Created by zhussupov on 11/22/18.
//  Copyright © 2018 Zhussupov. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK:- Properties
    
    // MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.mainBackgroundColor
        
        registerForKeyboardNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK:- Setup
    
    // MARK:- Actions
    
    func registerForKeyboardNotifications() {
        //    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeShown(notif:)), name: .UIKeyboardWillShow, object: nil)
        //    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notif:)), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeShown), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillBeShown(notif: Notification) {
        
        if let keyboardSize = (notif.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    @objc func keyboardWillHide(notif: Notification) {
        
        if let keyboardSize = (notif.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
        
    }
    
}

