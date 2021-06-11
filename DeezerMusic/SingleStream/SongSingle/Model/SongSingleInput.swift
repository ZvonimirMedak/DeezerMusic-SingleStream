//
//  SongSingleInput.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 23.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
enum SongSingleInput: Equatable{
    
    case viewDidLoad
    case usePlayer(_ finished: Bool = false)
    case back
    case songFinished
    case likeSong
    case skipSong
    case previousSong
    case none
    case deletePlaylist
}
