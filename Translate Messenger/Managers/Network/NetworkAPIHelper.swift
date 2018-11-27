//
//  NetworkAPIHelper.swift
//  Translate Messenger
//
//  Created by zhussupov on 11/24/18.
//  Copyright © 2018 Zhussupov. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

func sendRequest(_ url: String, parameters: [String: String], method: HTTPMethod, completion: @escaping ([String: Any]?, Error?) -> Void) {
    
    var components = URLComponents(string: url)!
    components.queryItems = parameters.map { (key, value) in
        URLQueryItem(name: key, value: value)
    }
    
    var request = URLRequest(url: components.url!)
    
    request.httpMethod = method.rawValue
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data,
            let response = response as? HTTPURLResponse,
            (200 ..< 300) ~= response.statusCode,
            error == nil else {
                completion(nil, error)
                return
        }
        
        let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
        completion(responseObject, nil)
    }
    task.resume()
}
