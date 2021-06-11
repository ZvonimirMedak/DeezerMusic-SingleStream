//
//  HomeCoordinator.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 22.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
import UIKit
class HomeCoordinator: NSObject, Coordinator {
    var navigationController: UINavigationController
    var homeViewController: HomeViewController!
    var childCoordinators: [Coordinator] = []
    var parentDelegate: ParentCoordinatorDelegate?
    
    init(navController: UINavigationController) {
        navigationController = navController
        super.init()
        homeViewController = createHomeViewController()
    }
    
    deinit{
        print("Deinit: \(self)")
    }
    
    func start() {
        navigationController.setNavigationBarHidden(true, animated: true)
        navigationController.pushViewController(homeViewController, animated: true)
    }

    func createHomeViewController() -> HomeViewController {
        let viewModel = HomeViewModelImpl(dependencies: HomeViewModelImpl.Dependencies(songRepository: SongRepositoryImpl(), likedSongsRepository: LikedSongsRepositoryImpl()))
        let viewController = HomeViewController(viewModel: viewModel)
        return viewController
    }
}
extension HomeCoordinator: CoordinatorDelegate, ParentCoordinatorDelegate{
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        parentDelegate?.childHasFinished(coordinator: self)
    }
    
    func childHasFinished(coordinator: Coordinator) {
        removeChildCoordinator(coordinator: coordinator)
    }
}

protocol HomeNavigationDelegate: AnyObject {
    func navigateToSongSingle(type: SongSingleType)
}
