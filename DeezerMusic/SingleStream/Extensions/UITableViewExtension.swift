//
//  UITableViewExtension.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 20/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation
import UIKit

extension UITableView{
    func dequeueCell<T: UITableViewCell>(identifier: String) -> T{
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? T else{return T()}
        return cell
    }
    
    func dequeueHeaderFooter<T: UITableViewHeaderFooterView>(identifier: String) -> T{
        guard let headerFooter = self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T else{return T()}
        return headerFooter
    }
}
