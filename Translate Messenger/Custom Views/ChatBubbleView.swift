//
//  BubbleView.swift
//  Translate Messenger
//
//  Created by zhussupov on 11/24/18.
//  Copyright © 2018 Zhussupov. All rights reserved.
//

import Foundation
import UIKit

class ChatBubbleView: BaseView {
    
    // MARK:- Properties
    
    var message: Message! {
        didSet {
            updateWith(message: message)
        }
    }
    
    private var corners: UIRectCorner = [.topLeft, .topRight, .bottomRight]
    
    private lazy var translationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK:- Setup
    
    override func setupView() {
        super.setupView()
        configureViews()
        configureConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 3.0
        roundCorners(corners: corners, radius: 16.0)
    }
    
    private func configureViews() {
        backgroundColor = Colors.themeColorBlue
        
        [messageLabel, translationLabel].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        
        [
            translationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
            translationLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            translationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0),
            
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0),
            messageLabel.topAnchor.constraint(equalTo: translationLabel.bottomAnchor, constant: 2.0),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0),
            
            widthAnchor.constraint(greaterThanOrEqualToConstant: 90.0)
            
            ].forEach { $0.isActive = true }
    }
    
    // MARK:- Actions
    
    private func updateWith(message: Message) {
        messageLabel.text = message.text
        translationLabel.text = message.translation
        
        backgroundColor = message.source == .outgoing ? Colors.themeColorBlue : Colors.themeColorRed
        
        if message.source == .outgoing {
            corners = [.topLeft, .topRight, .bottomRight]
        } else {
            corners = [.topLeft, .topRight, .bottomLeft]
        }
        
        layoutSubviews()
    }
}
