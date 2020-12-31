//
//  AppDelegate.swift
//  MoeAlert
//
//  Created by linyanzuo1222@gmail.com on 12/30/2020.
//  Copyright (c) 2020 linyanzuo1222@gmail.com. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = AlertUsageVC(style: .grouped)
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()

        return true
    }

}

