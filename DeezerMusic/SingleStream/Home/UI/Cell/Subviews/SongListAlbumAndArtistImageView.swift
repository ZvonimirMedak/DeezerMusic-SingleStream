//
//  SongListAlbumAndArtistImageView.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 12/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SongListAlbumAndArtistImageView: UIView{
    let albumCover: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 14
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "Placeholder")
        return imageView
    }()
    let artistCover: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "Placeholder")
        return imageView
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        self.addSubview(albumCover)
        self.addSubview(artistCover)
        setupConstraints()
    }
    
    private func setupConstraints(){
        albumCover.snp.makeConstraints { (maker) in
            maker.top.leading.equalToSuperview()
            maker.height.width.equalTo(100)
        }
        artistCover.snp.makeConstraints { (maker) in
            maker.top.equalTo(albumCover.snp.bottom).offset(10)
            maker.width.height.equalTo(50).priority(.high)
            maker.centerX.equalTo(albumCover)
            maker.bottom.equalToSuperview()
        }
    }
    
    func loadImage(album: String, artist: String){
        albumCover.loadImage(with: album)
        artistCover.loadImage(with: artist)
    }
    
}
