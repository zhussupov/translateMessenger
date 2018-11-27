//
//  Message.swift
//  Translate Messenger
//
//  Created by zhussupov on 11/24/18.
//  Copyright © 2018 Zhussupov. All rights reserved.
//

import Foundation

enum MessageSource {
    case incoming
    case outgoing
}

struct Message {
    
    var source: MessageSource
    var text: String
    var translation: String
    var primaryLanguage: Language
    
    init(text: String, source: MessageSource, primaryLanguage: Language, translation: String = "") {
        self.text = text
        self.source = source
        self.translation = translation
        self.primaryLanguage = primaryLanguage
    }
    
}
