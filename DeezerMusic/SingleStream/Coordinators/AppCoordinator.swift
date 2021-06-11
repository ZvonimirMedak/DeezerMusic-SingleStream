//
//  AppCoordinator.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 27/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation
import UIKit
class AppCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    var window: UIWindow
    var loginCoordinator: LoginCoordinator?
    
    init(window: UIWindow){
        self.window = window
    }
    
    func start() {
        let presenter = UINavigationController()
        self.loginCoordinator = LoginCoordinator(navController: presenter)
        window.rootViewController = presenter
        window.makeKeyAndVisible()
        
        guard let loginCoordinator = self.loginCoordinator else {return}
        self.addChildCoordinator(coordinator: loginCoordinator)
        loginCoordinator.start()
    }
}

extension AppCoordinator: CoordinatorDelegate{    
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        removeChildCoordinator(coordinator: self)
    }
}

