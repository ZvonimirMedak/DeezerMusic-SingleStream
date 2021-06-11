//
//  StyleManager.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 20/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation
import UIKit

enum ViewBackgroundStyle{
    case SongList, ContentView, DeleteView
}

class StyleManager{
    let songListBackground = UIColor.backgroundGray
    let songListContentBackground = UIColor.backgroundBlack
    let deleteBackground = UIColor.backgroundRed
    let labelTextColor = UIColor.labelColor
    
    static let shared = StyleManager()
    
    private init(){}
    
    func apply(for style: ViewBackgroundStyle, view: UIView){
        switch style {
        case .SongList:
            view.backgroundColor = songListBackground
        case .ContentView:
            view.backgroundColor = songListContentBackground
        case .DeleteView:
            view.backgroundColor = deleteBackground
        }
    }
    
    func apply(label: UILabel){
        label.textColor = labelTextColor
    }
}

