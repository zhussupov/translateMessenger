//
//  ChatRouter.swift
//  Translate Messenger
//
//  Created by zhussupov on 11/22/18.
//  Copyright © 2018 Zhussupov. All rights reserved.
//

import Foundation
import UIKit

class ChatRouter {
    
    // MARK: Properties
    
    weak var view: UIViewController?
    
    // MARK: Static methods
    
    static func setupModule() -> ChatViewController {
        let viewController = ChatViewController()
        let presenter = ChatPresenter()
        let router = ChatRouter()
        let interactor = ChatInteractor()
        
        viewController.presenter =  presenter
        
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        router.view = viewController
        
        interactor.output = presenter
        
        return viewController
    }
}

extension ChatRouter: ChatWireframe {
    func popBack() {
        self.view?.navigationController?.popViewController(animated: true)
    }
}
