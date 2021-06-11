//
//  HomeItem.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 20.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
public class HomeItem: HomeBaseItem{
    let item: SongViewItem

    init(identity: String, cellType: HomeCellType, item: SongViewItem) {
        self.item = item
        super.init(identity: identity, cellType: cellType)
    }
}

public class SongViewItem: Equatable {
    public static func == (lhs: SongViewItem, rhs: SongViewItem) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: Int
    let title: String
    let duration: Int
    let songPreviewURL: String
    let artist: Artist
    let album: Album
    let liked: Bool
    
    init(title: String, duration: Int, songPreviewURL: String, artist: Artist, album: Album, liked: Bool, id: Int) {
        self.title = title
        self.duration = duration
        self.songPreviewURL = songPreviewURL
        self.album = album
        self.artist = artist
        self.liked = liked
        self.id = id
    }
    
    init(songList: SongList, isLiked: Bool = false) {
        self.title = songList.title
        self.duration = songList.duration
        self.songPreviewURL = songList.preview
        self.artist = songList.artist
        self.album = songList.album
        self.liked = isLiked
        self.id = songList.id
        
    }
}
