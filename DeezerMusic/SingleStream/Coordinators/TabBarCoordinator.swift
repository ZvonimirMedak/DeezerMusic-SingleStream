//
//  TabBarCoordinator.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 26/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation
import UIKit
class TabBarCoordinator: NSObject, Coordinator{
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var tabController: UITabBarController!
    weak var parentDelegate: ParentCoordinatorDelegate?
    init(navController: UINavigationController){
        navigationController = navController
        super.init()
        tabController = createTabBarController()
    }
    
    func start() {
        navigationController.setNavigationBarHidden(true, animated: true)
        navigationController.pushViewController(tabController, animated: true)
    }
    
    func createTabBarController() -> UITabBarController{
        let tabController = UITabBarController()
        let homeScreenCoordinator = createHomeScreenCoordinator()
        homeScreenCoordinator.parentDelegate = self
        let playlistScreenCoordinator = createPlaylistScreenCoordinator()
        playlistScreenCoordinator.parentDelegate = self
        tabController.viewControllers = [homeScreenCoordinator.navigationController, playlistScreenCoordinator.navigationController]
        childCoordinators.append(homeScreenCoordinator)
        childCoordinators.append(playlistScreenCoordinator)
        homeScreenCoordinator.start()
        playlistScreenCoordinator.start()
        return tabController
    }
}

extension TabBarCoordinator{
    func createHomeScreenCoordinator() -> HomeCoordinator{
        let navigationController = UINavigationController()
        navigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "SongList"), tag: 0)
        return HomeCoordinator(navController: navigationController)
    }
    
    func createPlaylistScreenCoordinator() -> PlaylistsCoordinator{
        let navigationController = UINavigationController()
        navigationController.tabBarItem = UITabBarItem(title: "Playlists", image: UIImage(named: "Playlist"), tag: 1)
        return PlaylistsCoordinator(navController: navigationController, type: .playlists)
    }
}

extension TabBarCoordinator: ParentCoordinatorDelegate, CoordinatorDelegate{
    func childHasFinished(coordinator: Coordinator) {
        print(childCoordinators)
        removeChildCoordinator(coordinator: coordinator)
        print(childCoordinators)
    }
    
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        parentDelegate?.childHasFinished(coordinator: self)
    }
}
