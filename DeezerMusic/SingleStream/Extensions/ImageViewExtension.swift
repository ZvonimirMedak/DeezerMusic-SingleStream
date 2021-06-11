//
//  ImageViewExtension.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 12/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(with imageURL: String){
        self.image = R.image.placeholder()
        if imageURL != "Placeholder"{
            if let imageURL = URL(string: imageURL) {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: imageURL)
                    if let data = data {
                        let safeImage = UIImage(data: data)
                        DispatchQueue.main.async {[weak self] in
                            self?.image = safeImage
                        }
                    }
                }
            }
        }
    }
}
