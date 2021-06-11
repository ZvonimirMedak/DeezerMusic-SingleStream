//
//  HomeOutput.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 18.04.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
import RxDataSources
import RxCocoa

public struct HomeOutput{
    public var items: [HomeSectionItem]
    public var event: HomeOutputEvent?
}

public enum HomeOutputEvent{
    case popController
    case openDetails(item: SongViewItem)
    case error(_ message: String)
}

public struct HomeSectionItem: Equatable{
    public var identity: String
    public var items: [Item]
    
    public static func ==(lhs: HomeSectionItem, rhs: HomeSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }

    public init(identity: String, items: [Item]){
        self.identity = identity
        self.items = items
    }
}

extension HomeSectionItem: AnimatableSectionModelType{
    public typealias Item = HomeBaseItem
    public init(original: HomeSectionItem, items: [Item]) {
        self = original
        self.items = items
    }
}
