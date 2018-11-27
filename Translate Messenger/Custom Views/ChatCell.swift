//
//  ChatCell.swift
//  Translate Messenger
//
//  Created by zhussupov on 11/24/18.
//  Copyright © 2018 Zhussupov. All rights reserved.
//

import Foundation
import UIKit

class ChatCell: UITableViewCell {
    
    // MARK:- Properties
    
    var message: Message! {
        didSet {
            chatBubbleView.message = message
            adjustConstraints()
        }
    }
    
    private let chatBubbleView: ChatBubbleView = {
        let view = ChatBubbleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    // MARK:- Lifecycle
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK:- Setup
    
    private func configureViews() {
        [chatBubbleView].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        leadingConstraint = chatBubbleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.0)
        trailingConstraint = chatBubbleView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -100.0)
        [
            leadingConstraint,
            chatBubbleView.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
            trailingConstraint,
            chatBubbleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0)
            ].forEach { $0.isActive = true }
    }
    
    // MARK:- Actions
    
    private func adjustConstraints() {
        leadingConstraint.isActive = false
        trailingConstraint.isActive = false
        
        if message.source == .outgoing {
            leadingConstraint = chatBubbleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.0)
            trailingConstraint = chatBubbleView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -100.0)
        } else {
            leadingConstraint = chatBubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 100.0)
            trailingConstraint = chatBubbleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.0)
        }
        
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
    }
    
    func animate() {
        let translationX: CGFloat = message.source == .outgoing ? -50.0 : 50.0
        chatBubbleView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1).concatenating(CGAffineTransform(translationX: translationX, y: 50))
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveEaseOut], animations: {
            self.chatBubbleView.transform = .identity
        })
    }
}
