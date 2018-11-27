//
//  ChatViewController.swift
//  Translate Messenger
//
//  Created by zhussupov on 11/22/18.
//  Copyright © 2018 Zhussupov. All rights reserved.
//

import UIKit

class ChatViewController: BaseViewController {
    
    // MARK:- Properties
    
    var presenter: ChatPresentation?
    
    private lazy var yandexLogoImageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "yandexLogo")
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var messagesView: MessagesView = {
        let view = MessagesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var textInputViewBottomConstraint: NSLayoutConstraint!
    private lazy var textInputView: TextInputView = {
        let view = TextInputView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var keyboardHeight: CGFloat = 0.0 {
        didSet {
            adjustContentInsets()
            messagesView.scrollToBottom()
        }
    }
    
    var dummySent = false
    
    // MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureConstraints()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
    }
    
    // MARK:- Setup
    
    fileprivate func configureViews() {
        [yandexLogoImageView, messagesView, textInputView].forEach {
            view.addSubview($0)
        }
    }
    
    fileprivate func configureConstraints() {
        
        textInputViewBottomConstraint = textInputView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4.0)
        
        [
            yandexLogoImageView.widthAnchor.constraint(equalToConstant: 142.82),
            yandexLogoImageView.heightAnchor.constraint(equalToConstant: 20.9),
            yandexLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            yandexLogoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0),
            
            messagesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messagesView.topAnchor.constraint(equalTo: yandexLogoImageView.bottomAnchor, constant: 20.0),
            messagesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messagesView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
            
            textInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4.0),
            textInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4.0),
            textInputViewBottomConstraint
            
            ].forEach { $0.isActive = true }
    }
    
    // MARK:- Actions
    
    @objc func didTap() {
        textInputView.resignResponder()
    }
    
    override func keyboardWillBeShown(notif: Notification) {
        if let keyboardSize = (notif.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardHeight = keyboardSize.height
        }
    }
    
    override func keyboardWillHide(notif: Notification) {
        keyboardHeight = 0.0
    }
    
    func adjustContentInsets(animated: Bool = true) {
        
        textInputViewBottomConstraint.constant = -4.0 - keyboardHeight
        if animated {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.7, options: [.curveEaseOut, .allowUserInteraction], animations: {
                self.view.layoutSubviews()
            })
        } else {
            view.layoutSubviews()
        }
        
        let textInputViewHeight = textInputView.frame.height
        let bottomInset = textInputViewHeight + 10.0 + keyboardHeight
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, bottomInset, 0.0)
        messagesView.messagesTableView.contentInset = contentInsets
        messagesView.messagesTableView.scrollIndicatorInsets = contentInsets
        
    }
    
    private func sendDummyMessage() {
        let text = "Tell me how to get to the library?"
        let translation = "Подскажите, как пройти в библиотеку?"
        let message = Message(text: text, source: .incoming, primaryLanguage: .En, translation: translation)
        messagesView.addMessage(message: message)
        messagesView.scrollToBottom()
    }
    
}

extension ChatViewController: TextInputViewDelegate {
    
    func didTapSend(with message: Message) {
        textInputView.showActivityIndicator()
        presenter?.didTapSend(message: message)
    }
    
    func textInputViewHeightChanged(to height: CGFloat) {
        adjustContentInsets(animated: false)
        messagesView.scrollToBottom()
    }
    
}

extension ChatViewController: ChatView {
    
    func gotTranslatedMessage(message: Message?) {
        guard let message = message else {
            textInputView.hideActivitoIndicator()
            return
        }
        
        DispatchQueue.main.async {
            self.textInputView.clearTextField()
            self.textInputView.hideActivitoIndicator()
            self.messagesView.addMessage(message: message)
            self.messagesView.scrollToBottom()
        }
        
        
        if !dummySent {
            dummySent = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.sendDummyMessage()
            }
        }
    }
    
}
