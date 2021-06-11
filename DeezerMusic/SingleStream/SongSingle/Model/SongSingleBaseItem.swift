//
//  SongSingleBaseItem.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 23.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
import RxDataSources

public class SongSingleBaseItem: IdentifiableType, Equatable{
    public static func ==(lhs: SongSingleBaseItem, rhs: SongSingleBaseItem) -> Bool {
        lhs.identity == rhs.identity
    }
    
    public let identity: String
    public var cellType: SongSingleCellType
    
    
    public init(identity: String, cellType: SongSingleCellType){
        self.identity = identity
        self.cellType = cellType
    }
    
}
