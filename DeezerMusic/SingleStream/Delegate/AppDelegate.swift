//
//  AppDelegate.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 11/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else {return false}
        self.appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
        FirebaseApp.configure()
        return true
    }


}

