//
//  LanguageView.swift
//  Translate Messenger
//
//  Created by zhussupov on 11/23/18.
//  Copyright © 2018 Zhussupov. All rights reserved.
//

import Foundation
import UIKit

protocol LanguageViewDelegate: class {
    func didChangeLanguage(to language: Language)
}

class LanguageView: BaseView {
    
    // MARK:- Properties
    
    weak var delegate: LanguageViewDelegate?
    
    private let minLeadingConstant: CGFloat = 2.0
    private let maxLeadingConstant: CGFloat = 12.0
    
    public var language: Language = .Ru {
        didSet {
            changeLanguage(language: language)
        }
    }
    
    private var engImageViewLeadingConstraint: NSLayoutConstraint!
    private lazy var engImageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "engFlag")
        view.layer.cornerRadius = 16.0
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var ruImageViewLeadingConstraint: NSLayoutConstraint!
    private lazy var ruImageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "ruFlag")
        view.layer.cornerRadius = 16.0
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK:- Setup
    
    override func setupView() {
        super.setupView()
        configureViews()
        configureConstraints()
        changeLanguage(language: .Ru)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }
    
    private func configureViews() {
        layer.cornerRadius = 18.0
        backgroundColor = .white
        
        
        
        [engImageView, ruImageView].forEach {
            addSubview($0)
        }
        
    }
    
    private func configureConstraints() {
        [
            heightAnchor.constraint(equalToConstant: 36.0),
            widthAnchor.constraint(equalToConstant: 46.0)
            ].forEach { $0.isActive = true }
        
        engImageViewLeadingConstraint = engImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: minLeadingConstant)
        ruImageViewLeadingConstraint = ruImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: maxLeadingConstant)
        
        [
            engImageView.widthAnchor.constraint(equalToConstant: 32.0),
            engImageView.heightAnchor.constraint(equalToConstant: 32.0),
            engImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            engImageViewLeadingConstraint,
            
            ruImageView.widthAnchor.constraint(equalToConstant: 32.0),
            ruImageView.heightAnchor.constraint(equalToConstant: 32.0),
            ruImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            ruImageViewLeadingConstraint
            ].forEach { $0?.isActive = true }
        
    }
    
    // MARK:- Actions
    
    @objc private func handleTap() {
        toggle()
    }
    
    private func toggle() {
        language = language == .Ru ? .En : .Ru
    }
    
    private func changeLanguage(language: Language, animated: Bool = true) {
        
        delegate?.didChangeLanguage(to: language)
        
        if language == .Ru {
            bringSubview(toFront: ruImageView)
            ruImageViewLeadingConstraint.constant = maxLeadingConstant
            engImageViewLeadingConstraint.constant = minLeadingConstant
        } else {
            bringSubview(toFront: engImageView)
            ruImageViewLeadingConstraint.constant = minLeadingConstant
            engImageViewLeadingConstraint.constant = maxLeadingConstant
        }
        
        if animated {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveEaseOut, .allowUserInteraction], animations: {
                self.layoutSubviews()
            })
        }
    }
    
}


