//
//  UIScrollViewExtension.swift
//  Translate Messenger
//
//  Created by zhussupov on 11/22/18.
//  Copyright © 2018 Zhussupov. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    func scroll(toView: UIView, animated: Bool) {
        let rect = toView.frame
        let maxOffset = contentSize.height - bounds.size.height + contentInset.bottom
        let offset = min(rect.origin.y, maxOffset)
        setContentOffset(CGPoint.init(x: 0.0, y: offset), animated: animated)
    }
    
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    func scrollToBottom(animated: Bool) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: animated)
        }
    }
    
}
