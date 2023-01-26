//
//  AppDelegate.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 20/04/2020.
//  Copyright © 2020 UltraDev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.window = initializeWindow()
        return true
    }

    private func initializeWindow() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = setupRootViewController()
        window.makeKeyAndVisible()
        return window
    }

    private func setupRootViewController() -> UIViewController {
        let navigationController = UINavigationController(rootViewController: RepositoriesViewController())
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.tintColor = .repoSearchGray
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.repoSearchGray]
        return navigationController
    }
}
