//
//  SongSingleAlbumImageTableViewCell.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 23.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class SongSingleAlbumImageTableViewCell: UITableViewCell {
    let albumImage: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        let subviews = [albumImage]
        contentView.addSubviews(views: subviews)
        selectionStyle = .none
        contentView.tintColor = .clear
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        setupConstraints()
    }
    
    private func setupConstraints(){
        albumImage.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview().inset(UIEdgeInsets(top: 50, left: 0, bottom: 50, right: 0))
            make.width.height.equalTo(200).priority(.high)
        }
    }
    
    func configure(imageURL: String){
        albumImage.loadImage(with: imageURL)
    }
}
