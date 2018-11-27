//
//  ChatContract.swift
//  Translate Messenger
//
//  Created by zhussupov on 11/22/18.
//  Copyright © 2018 Zhussupov. All rights reserved.
//

import Foundation

protocol ChatView: class {
    func gotTranslatedMessage(message: Message?)
}

protocol ChatPresentation: class {
    func refresh()
    func didTapBack()
    func didTapSend(message: Message)
}

protocol ChatUseCase: class {
    func translate(message: Message)
}

protocol ChatInteractorOutput: class {
    func gotTranslation(message: Message)
    func errorGettingTranslation()
}

protocol ChatWireframe: class {
    func popBack()
}
