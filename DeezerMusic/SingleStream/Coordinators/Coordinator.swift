//
//  Coordinator.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 26/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation
import UIKit
protocol Coordinator: class{
    var childCoordinators: [Coordinator] {get set}
    
    func start()
}

extension Coordinator{
    func addChildCoordinator(coordinator: Coordinator){
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(coordinator: Coordinator){
        childCoordinators = childCoordinators.filter{ $0 !== coordinator}
    }
}
