//
//  HomeBaseItem.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 20.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
import RxDataSources

public class HomeBaseItem: IdentifiableType, Equatable{
    public static func ==(lhs: HomeBaseItem, rhs: HomeBaseItem) -> Bool {
        lhs.identity == rhs.identity && lhs.cellType == rhs.cellType
    }
    
    public let identity: String
    public var cellType: HomeCellType
    
    
    public init(identity: String, cellType: HomeCellType){
        self.identity = identity
        self.cellType = cellType
    }
    
}

public enum HomeCellType {
    case song
}
