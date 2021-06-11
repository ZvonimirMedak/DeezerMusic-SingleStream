//
//  SongSingleCoordinator.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 26.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
import UIKit
class SongSingleCoordinator: NSObject, Coordinator {
    var presentingViewController: UIViewController
    var songSingleViewController: SongSingleViewController!
    var childCoordinators: [Coordinator] = []
    var parentDelegate: ParentCoordinatorDelegate?
    
    init(presentingViewController: UIViewController, type: SongSingleType) {
        self.presentingViewController = presentingViewController
        super.init()
        songSingleViewController = createSongSingleViewController(type)
    }
    
    deinit{
        print("Deinit: \(self)")
    }
    
    func start() {
        presentingViewController.present(songSingleViewController, animated: true, completion: nil)
    }

    func createSongSingleViewController(_ type: SongSingleType) -> SongSingleViewController {
        let viewModel = SongSingleViewModelImpl(dependencies: SongSingleViewModelImpl.Dependencies(songSingleType: type, likedSongsRepository: LikedSongsRepositoryImpl(), playlistsRepository: PlaylistsRepositoryImpl()))
        let viewController = SongSingleViewController(viewModel: viewModel)
        viewController.songSingleNavigationDelegate = self
        viewController.coordinatorDelegate = self
        return viewController
    }
}
extension SongSingleCoordinator: CoordinatorDelegate, ParentCoordinatorDelegate{
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        parentDelegate?.childHasFinished(coordinator: self)
    }
    
    func childHasFinished(coordinator: Coordinator) {
        removeChildCoordinator(coordinator: coordinator)
    }
}

extension SongSingleCoordinator: SongSingleNavigationDelegate {
    func navigateToAddToPlaylist(item: SongSingleViewItem) {
        let playlistsCoordinator = PlaylistsCoordinator(navController: UINavigationController(), type: .addToPlaylist(song: item))
        addChildCoordinator(coordinator: playlistsCoordinator)
        songSingleViewController.present(playlistsCoordinator.playlistsViewController, animated: true, completion: nil)
    }
}

protocol SongSingleNavigationDelegate: AnyObject {
    func navigateToAddToPlaylist(item: SongSingleViewItem)
}

