//
//  StringExtension.swift
//  Translate Messenger
//
//  Created by zhussupov on 11/22/18.
//  Copyright © 2018 Zhussupov. All rights reserved.
//

import Foundation

extension String {
    subscript (i: Int) -> Character? {
        if i < count {
            return self[index(startIndex, offsetBy: i)]
        } else {
            return nil
        }
    }
}
