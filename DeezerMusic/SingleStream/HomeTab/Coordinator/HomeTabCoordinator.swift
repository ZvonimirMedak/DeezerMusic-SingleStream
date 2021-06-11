//
//  HomeTabCoordinator.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 25.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
import SwipeableTabBarController
import UIKit
class HomeTabCoordinator: NSObject, Coordinator {
    var navigationController: UINavigationController
    var tabController: SwipeableTabBarController!
    var childCoordinators: [Coordinator] = []
    var parentDelegate: ParentCoordinatorDelegate?
    
    init(navController: UINavigationController) {
        navigationController = navController
        super.init()
        tabController = createHomeTabController()
    }
    
    deinit{
        print("Deinit: \(self)")
    }
    
    func start() {
        navigationController.setNavigationBarHidden(true, animated: true)
        navigationController.pushViewController(tabController, animated: true)
    }

    func createHomeTabController() -> SwipeableTabBarController {
        let viewController = SwipeableTabBarController()
        let homeCoordinator = createHomeCoordinator()
        let playlistsCoordinator = createPlaylistsCoordinator()
        viewController.viewControllers = [homeCoordinator.homeViewController, playlistsCoordinator.playlistsViewController]
        return viewController
    }
}

private extension HomeTabCoordinator {
    func createHomeCoordinator() -> HomeCoordinator {
        let coordinator = HomeCoordinator(navController: navigationController)
        coordinator.homeViewController.homeNavigationDelegate = self
        coordinator.homeViewController.tabBarItem = UITabBarItem(title: R.string.localizable.songs(), image: R.image.songList(), tag: 0)
        addChildCoordinator(coordinator: coordinator)
        return coordinator
    }
    
    func createPlaylistsCoordinator() -> PlaylistsCoordinator {
        let coordinator = PlaylistsCoordinator(navController: navigationController, type: .playlists)
        coordinator.playlistsViewController.tabBarItem = UITabBarItem(title: R.string.localizable.playlists(), image: R.image.playlist(), tag: 0)
        coordinator.playlistsViewController.homeNavigationDelegate = self
        addChildCoordinator(coordinator: coordinator)
        return coordinator
    }
}

extension HomeTabCoordinator: CoordinatorDelegate, ParentCoordinatorDelegate{
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        parentDelegate?.childHasFinished(coordinator: self)
    }
    
    func childHasFinished(coordinator: Coordinator) {
        removeChildCoordinator(coordinator: coordinator)
    }
}

extension HomeTabCoordinator: HomeNavigationDelegate {

    func navigateToSongSingle(type: SongSingleType) {
        let coordinator = SongSingleCoordinator(presentingViewController: tabController, type: type)
        coordinator.parentDelegate = self
        addChildCoordinator(coordinator: coordinator)
        coordinator.start()
    }
}

