//
//  AppDelegate.swift
//  exchange
//
//  Created by Sergey Kim on 24.08.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDependenceProvider().configure()

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = ExchangeConfigurator.create()
        window?.makeKeyAndVisible()
        return true
    }
}

