//
//  UIViewExtension.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 12/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(views: [UIView]){
        for view in views{
            self.addSubview(view)
        }
    }
}
