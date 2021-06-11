//
//  UIViewControllerExtension.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 20/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func showAlertWith(title: String, message: String, handler: @escaping ((UITextField)->Void) = {_ in }, action: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil), anotherAction: UIAlertAction? = nil){
        let alert: UIAlertController = {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addTextField(configurationHandler: handler)
            alert.addAction(action)
            if anotherAction != nil {
                alert.addAction(anotherAction!)
            }
            return alert
        }()
        self.present(alert, animated: true, completion: nil)
    }
    
    func showMessageAlert(title: String, message: String) {
        let alert: UIAlertController = {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            return alert
        }()
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
