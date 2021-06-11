//
//  PlaylistsCoordinator.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 26.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
import UIKit
class PlaylistsCoordinator: NSObject, Coordinator {
    var navigationController: UINavigationController
    var playlistsViewController: HomePlaylistsViewController!
    var childCoordinators: [Coordinator] = []
    var parentDelegate: ParentCoordinatorDelegate?
    
    init(navController: UINavigationController, type: PlaylistType) {
        navigationController = navController
        super.init()
        playlistsViewController = createHomePlaylistsViewController(type)
    }
    
    deinit{
        print("Deinit: \(self)")
    }
    
    func start() {
        navigationController.setNavigationBarHidden(true, animated: true)
        navigationController.pushViewController(playlistsViewController, animated: true)
    }

    func createHomePlaylistsViewController(_ type: PlaylistType) -> HomePlaylistsViewController {
        let viewModel = HomePlaylistsViewModelImpl(dependencies: HomePlaylistsViewModelImpl.Dependencies(playlistsRepository: PlaylistsRepositoryImpl(), likedSongsRepository: LikedSongsRepositoryImpl(), playlistType: type))
        let viewController = HomePlaylistsViewController(viewModel: viewModel)
        return viewController
    }
}
extension PlaylistsCoordinator: CoordinatorDelegate, ParentCoordinatorDelegate{
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        parentDelegate?.childHasFinished(coordinator: self)
    }
    
    func childHasFinished(coordinator: Coordinator) {
        removeChildCoordinator(coordinator: coordinator)
    }
}
