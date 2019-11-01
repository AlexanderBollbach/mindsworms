//
//  AppDelegate.swift
//  mindworms-2
//
//  Created by Alexander Bollbach on 9/2/19.
//  Copyright © 2019 Alexander Bollbach. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        
        
        return true
        
    }
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration { UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role) }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("terminate")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("resign active")
    }
}

