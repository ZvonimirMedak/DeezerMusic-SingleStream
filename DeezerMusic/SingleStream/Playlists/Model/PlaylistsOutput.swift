//
//  PlaylistsOutput.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 26.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
import RxDataSources
import RxCocoa

public struct PlaylistsOutput{
    public var items: [PlaylistsSectionItem]
    public var event: PlaylistsOutputEvent?
}

public enum PlaylistsOutputEvent{
    case openDetails(songs: PlaylistsViewItem)
    case dismissVC
    case alert
    case error(_ message: String)
}

public struct PlaylistsSectionItem: Equatable{
    public var identity: String
    public var items: [Item]
    
    public static func ==(lhs: PlaylistsSectionItem, rhs: PlaylistsSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }

    public init(identity: String, items: [Item]){
        self.identity = identity
        self.items = items
    }
}

extension PlaylistsSectionItem: AnimatableSectionModelType{
    public typealias Item = PlaylistsBaseItem
    public init(original: PlaylistsSectionItem, items: [Item]) {
        self = original
        self.items = items
    }
}
