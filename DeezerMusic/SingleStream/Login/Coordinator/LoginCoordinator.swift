//
//  LoginCoordinator.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 22.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
import UIKit
import SwipeableTabBarController
class LoginCoordinator:NSObject, Coordinator{
    var navigationController: UINavigationController
    var loginViewController: LoginViewController!
    var childCoordinators: [Coordinator] = []
    weak var parentDelegate: ParentCoordinatorDelegate?
    var tabBarController: SwipeableTabBarController?
    
    init(navController: UINavigationController) {
        navigationController = navController
        super.init()
        loginViewController = createLoginViewController()
    }
    
    deinit{
        print("Deinit: \(self)")
    }
    
    func start() {
        navigationController.setNavigationBarHidden(true, animated: true)
        navigationController.pushViewController(loginViewController, animated: true)
    }
    
    func createLoginViewController() -> LoginViewController{
        let viewModel = LoginViewModelImpl()
        let viewController = LoginViewController(viewModel: viewModel)
        viewController.loginNavigationDelegate = self
        return viewController
    }
}

extension LoginCoordinator: CoordinatorDelegate, ParentCoordinatorDelegate{
    func childHasFinished(coordinator: Coordinator) {
        removeChildCoordinator(coordinator: coordinator)
    }
    
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        parentDelegate?.childHasFinished(coordinator: self)
    }
}

extension LoginCoordinator: LoginNavigationDelegate {
    func openHomeScreen() {
        let tabCoordinator = HomeTabCoordinator(navController: navigationController)
        addChildCoordinator(coordinator: tabCoordinator)
        tabCoordinator.start()
    }
}

protocol LoginNavigationDelegate: AnyObject {
    func openHomeScreen()
}
