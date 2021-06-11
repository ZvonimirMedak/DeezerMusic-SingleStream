//
//  SongTableViewCell.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 12/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SongTableViewCell: UITableViewCell{
    let images: SongListAlbumAndArtistImageView = {
        let imageView = SongListAlbumAndArtistImageView()
        return imageView
    }()
    let songLabels: SongListSongAndAlbumLabelsView = {
        let labels = SongListSongAndAlbumLabelsView()
        return labels
    }()
    let artistName: UILabel = {
        let label = UILabel()
        StyleManager.shared.apply(label: label)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        let subviews = [images, artistName, songLabels]
        contentView.addSubviews(views: subviews)
        selectionStyle = .none
        setupConstraints()
    }
    
    private func setupConstraints(){
        images.snp.makeConstraints { (maker) in
            maker.leading.top.bottom.equalToSuperview().inset(15)
            maker.width.equalTo(100).priority(.high)
        }
        artistName.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(images.snp.bottom).offset(-10)
            maker.leading.equalTo(images.snp.trailing).offset(25)
            maker.trailing.equalToSuperview().inset(15)
        }
        songLabels.snp.makeConstraints { (maker) in
            maker.top.equalTo(images.snp.top)
            maker.leading.equalTo(images.snp.trailing).offset(25)
            maker.trailing.equalToSuperview().inset(15)
        }
    }
    
    func configure(title: String, albumURL: String, artistURL: String, duration: Int, albumName: String, artist: String){
        songLabels.configureLabels(song: title, duration: duration)
        images.loadImage(album: albumURL, artist: artistURL)
        artistName.text = artist
    }
}
