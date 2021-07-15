//
//  AppDelegate.swift
//  testleboncoin
//
//  Created by zhizi yuan on 15/07/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()

        let navigationViewController = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()

        return true
    }


}

