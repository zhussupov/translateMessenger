//
//  TranslateAPIService.swift
//  Translate Messenger
//
//  Created by zhussupov on 11/22/18.
//  Copyright © 2018 Zhussupov. All rights reserved.
//

import Foundation

class TranslateAPIService {
    
    static func detect(text: String, completion: @escaping ([String: Any]?, Error?) -> ()) {
        
        let urlString = NetworkConstants.APIDetectUrl
        
        let params = [
            "key" : NetworkConstants.APIKey,
            "text" : text,
            ]
        
        sendRequest(urlString, parameters: params, method: .post) { (response, error) in
            
            guard let response = response, error == nil else {
                completion(nil, error)
                return
            }
            
            completion(response, nil)
            
        }
        
    }
    
    static func translate(text: String, from lang: Language, completion: @escaping ([String: Any]?, Error?) -> ()) {
        
        let urlString = NetworkConstants.APITranslateUrl
        
        let translationFromTo = lang == .En ? "en-ru" : "ru-en"
        
        let params = [
            "key" : NetworkConstants.APIKey,
            "text" : text,
            "lang" : translationFromTo,
            "format" : "plain"
        ]
        
        sendRequest(urlString, parameters: params, method: .post) { (response, error) in
            
            guard let response = response, error == nil else {
                completion(nil, error)
                return
            }
            
            completion(response, nil)
            
        }
    }
}
