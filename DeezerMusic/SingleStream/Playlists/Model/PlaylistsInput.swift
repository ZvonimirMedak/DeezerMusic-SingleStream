//
//  PlaylistsInput.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 26.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
enum PlaylistsInput: Equatable{
    case viewDidLoad
    case none
    case indexSelected(index: IndexPath)
    case newPlaylist(name: String)
}
