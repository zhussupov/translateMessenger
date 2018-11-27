//
//  ChatPresenter.swift
//  Translate Messenger
//
//  Created by zhussupov on 11/22/18.
//  Copyright © 2018 Zhussupov. All rights reserved.
//

import Foundation

class ChatPresenter {
    
    // MARK: Properties
    
    weak var view: ChatView?
    var router: ChatWireframe?
    var interactor: ChatUseCase?
}

extension ChatPresenter: ChatPresentation {
    func refresh() {
        
    }
    
    func didTapBack() {
        router?.popBack()
    }
    
    func didTapSend(message: Message) {
        interactor?.translate(message: message)
    }
    
}

extension ChatPresenter: ChatInteractorOutput {
    
    func gotTranslation(message: Message) {
        view?.gotTranslatedMessage(message: message)
    }
    
    func errorGettingTranslation() {
        view?.gotTranslatedMessage(message: nil)
    }
}
