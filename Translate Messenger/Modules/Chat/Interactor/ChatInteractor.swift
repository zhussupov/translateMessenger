//
//  ChatInteractor.swift
//  Translate Messenger
//
//  Created by zhussupov on 11/22/18.
//  Copyright © 2018 Zhussupov. All rights reserved.
//

import Foundation

class ChatInteractor {
    
    // MARK: Properties
    
    weak var output: ChatInteractorOutput?
}

extension ChatInteractor: ChatUseCase {
    
    private func translateWithDetectedLang(message: Message, from lang: Language) {
        
        let text = message.text
        
        TranslateAPIService.translate(text: text, from: lang) { (response, error) in
            guard let response = response, error == nil else {
                print(error ?? "Unknown error")
                self.output?.errorGettingTranslation()
                return
            }
            
            if let translation = response["text"] as? [String] {
                let resultMessage = Message(text: text, source: message.source, primaryLanguage: lang, translation: translation[0])
                self.output?.gotTranslation(message: resultMessage)
            } else {
                self.output?.errorGettingTranslation()
            }
        }
        
    }
    
    func translate(message: Message) {
        let text = message.text
        let lang = message.primaryLanguage
        
        TranslateAPIService.detect(text: text) { (response, error) in
            guard let response = response, error == nil else {
                print(error ?? "Unknown error detecting language")
                self.output?.errorGettingTranslation()
                return
            }
            
            if let detected = response["lang"] as? String {
                if detected == "ru" {
                    self.translateWithDetectedLang(message: message, from: .Ru)
                } else if detected == "en" {
                    self.translateWithDetectedLang(message: message, from: .En)
                } else {
                    self.translateWithDetectedLang(message: message, from: lang)
                }
                
            } else {
                self.output?.errorGettingTranslation()
            }
            
        }
        
    }
    
}
