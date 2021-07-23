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

        let navigationViewController = UINavigationController(rootViewController: AdvertListViewController())
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()

        //configure navigation bar
        UINavigationBar.appearance().barTintColor = .leboncoinOrange
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]

        return true
    }
}
