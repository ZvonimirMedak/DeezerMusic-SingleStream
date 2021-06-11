//
//  SongSingleOutput.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 23.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
import RxDataSources
import RxCocoa

public struct SongSingleOutput{
    public var items: [SongSingleSectionItem]
    public var event: SongSingleOutputEvent?
}

public enum SongSingleOutputEvent{
    case popController
    case newSong
}

public struct SongSingleSectionItem: Equatable{
    public var identity: String
    public var items: [Item]
    
    public static func ==(lhs: SongSingleSectionItem, rhs: SongSingleSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }

    public init(identity: String, items: [Item]){
        self.identity = identity
        self.items = items
    }
}

extension SongSingleSectionItem: AnimatableSectionModelType{
    public typealias Item = SongSingleBaseItem
    public init(original: SongSingleSectionItem, items: [Item]) {
        self = original
        self.items = items
    }
}
public enum SongSingleCellType{
    
    case header(type: SongSingleType)
    case albumImage
    case description(type: SongSingleType)
    case player
    case playlistPlayer
}
