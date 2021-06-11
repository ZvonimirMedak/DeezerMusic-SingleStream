//
//  PlaylistsBaseItem.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 26.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
import RxDataSources

public class PlaylistsBaseItem: IdentifiableType, Equatable{
    public static func ==(lhs: PlaylistsBaseItem, rhs: PlaylistsBaseItem) -> Bool {
        lhs.identity == rhs.identity && lhs.cellType == rhs.cellType
    }
    
    public let identity: String
    public var cellType: PlaylistsCellType
    
    
    public init(identity: String, cellType: PlaylistsCellType){
        self.identity = identity
        self.cellType = cellType
    }
    
}

public enum PlaylistsCellType {
    case playlist
    case newPlaylist
}
