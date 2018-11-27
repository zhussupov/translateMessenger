//
//  RecordingView.swift
//  Translate Messenger
//
//  Created by zhussupov on 11/26/18.
//  Copyright © 2018 Zhussupov. All rights reserved.
//

import Foundation
import UIKit

class RecordingView: BaseView {
    
    // MARK:- Properties
    
    private lazy var views: [UIView] = {
        var views: [UIView] = []
        for i in 0..<5 {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.cornerRadius = 3.0
            view.translatesAutoresizingMaskIntoConstraints = false
            views.append(view)
        }
        return views
    }()
    
    // MARK:- Setup
    
    override func setupView() {
        super.setupView()
        configureViews()
        configureConstraints()
    }
    
    private func configureViews() {
        views.forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [
            widthAnchor.constraint(equalToConstant: 18.0),
            heightAnchor.constraint(equalToConstant: 16.0)
            ].forEach { $0.isActive = true }
        
        views[0].leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        views[0].centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        views[0].heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        views[0].widthAnchor.constraint(equalToConstant: 2.0).isActive = true
        for i in 1..<5 {
            [
                views[i].leadingAnchor.constraint(equalTo: views[i-1].trailingAnchor, constant: 2.0),
                views[i].centerYAnchor.constraint(equalTo: centerYAnchor),
                views[i].heightAnchor.constraint(equalTo: heightAnchor),
                views[i].widthAnchor.constraint(equalToConstant: 2.0)
                ].forEach { $0.isActive = true }
        }
    }
    
    // MARK:- Actions
    
    func animate() {
        let animation = CABasicAnimation(keyPath: "transform.scale.y")
        animation.duration = 0.5
        animation.repeatCount = .infinity
        animation.autoreverses = true
        animation.fromValue = 0.1
        animation.toValue = 1
        
        for i in views.indices {
            views[i].transform = CGAffineTransform(scaleX: 1, y: 0.1)
        }
        
        views[2].layer.add(animation, forKey: "transform.scale.y")
        
        animation.beginTime = CACurrentMediaTime() + 0.3
        views[1].layer.add(animation, forKey: "transform.scale.y")
        views[3].layer.add(animation, forKey: "transform.scale.y")
        
        animation.beginTime = CACurrentMediaTime() + 0.6
        views[0].layer.add(animation, forKey: "transform.scale.y")
        views[4].layer.add(animation, forKey: "transform.scale.y")
        
    }
}
