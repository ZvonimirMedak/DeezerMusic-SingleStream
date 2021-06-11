//
//  PlaylistsItem.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 26.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
public class PlaylistsItem: PlaylistsBaseItem{
    let item: PlaylistsViewItem

    init(identity: String, cellType: PlaylistsCellType, item: PlaylistsViewItem) {
        self.item = item
        super.init(identity: identity, cellType: cellType)
    }
}

public class PlaylistsViewItem: Equatable {
    public static func == (lhs: PlaylistsViewItem, rhs: PlaylistsViewItem) -> Bool {
        lhs.title == rhs.title
    }
    
    let songs: [SongSingleViewItem]
    let title: String
    
    init(songs: [SongSingleViewItem], title: String) {
        self.songs = songs
        self.title = title
    }
}

