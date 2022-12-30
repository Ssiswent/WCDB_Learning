//
//  AppDelegate.swift
//  WCDB_Learning
//
//  Created by Flamingo on 2021/3/29.
//

import UIKit
import YPNavigationBarTransition

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navC = BaseNavigationController(rootViewController: PersonListVC())
        window?.rootViewController = navC
        window?.makeKeyAndVisible()
        return true
    }
}
