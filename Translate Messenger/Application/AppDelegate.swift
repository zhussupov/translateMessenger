//
//  AppDelegate.swift
//  Translate Messenger
//
//  Created by zhussupov on 11/21/18.
//  Copyright © 2018 Zhussupov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        DesignUtil.configureToAppAppearance()
        
        window = UIWindow()
        
        let vc = ChatRouter.setupModule()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        return true
    }
    
}

