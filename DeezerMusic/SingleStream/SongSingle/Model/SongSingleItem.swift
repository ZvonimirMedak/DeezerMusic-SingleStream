//
//  SongSingleItem.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 23.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation

public class SongSingleItem: SongSingleBaseItem{
    let item: SongSingleViewItem

    init(identity: String, cellType: SongSingleCellType, item: SongSingleViewItem) {
        self.item = item
        super.init(identity: identity, cellType: cellType)
    }
}


public class SongSingleViewItem: Codable, Equatable {
    public static func == (lhs: SongSingleViewItem, rhs: SongSingleViewItem) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: Int
    let title: String
    let songPreviewURL: String
    let artistName: String
    let albumName: String
    let albumImage: String
    var isLiked: Bool
    
    init(songItem: SongViewItem) {
        self.id = songItem.id
        self.title = songItem.title
        self.songPreviewURL = songItem.songPreviewURL
        self.artistName = songItem.artist.name
        self.albumImage = songItem.album.cover
        self.albumName = songItem.album.title
        self.isLiked = songItem.liked
    }
    
    init(dict: [String: Any]) {
        self.id = dict["id"] as! Int
        self.title = dict["title"] as! String
        self.songPreviewURL = dict["songPreviewURL"] as! String
        self.artistName = dict["artistName"] as! String
        self.albumImage = dict["albumImage"] as! String
        self.albumName = dict["albumName"] as! String
        self.isLiked = dict["isLiked"] as! Bool
    }
    
    public func toDict() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["id"] = self.id
        dict["title"] = self.title
        dict["songPreviewURL"] = self.songPreviewURL
        dict["artistName"] = self.artistName
        dict["albumName"] = self.albumName
        dict["albumImage"] = self.albumImage
        dict["isLiked"] = self.isLiked
        return dict
    }
    
}
