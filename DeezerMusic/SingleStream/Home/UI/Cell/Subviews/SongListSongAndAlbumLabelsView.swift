//
//  SongListSongAndAlbumLabels.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 12/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SongListSongAndAlbumLabelsView: UIView {
    let songTitle: UILabel = {
        let label = UILabel()
        StyleManager.shared.apply(label: label)
        return label
    }()
    
    let songDuration: UILabel = {
        let label = UILabel()
        StyleManager.shared.apply(label: label)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        let subviews = [songTitle, songDuration]
        self.addSubviews(views: subviews)
        setupConstraints()
    }
    
    private func setupConstraints(){
        songTitle.snp.makeConstraints { (maker) in
            maker.leading.top.trailing.equalToSuperview()
        }
        songDuration.snp.makeConstraints { (maker) in
            maker.top.equalTo(songTitle.snp.bottom).offset(10)
            maker.leading.trailing.equalToSuperview()
        }
    }
    
    func configureLabels(song: String, duration: Int){
        songTitle.text = song
        songDuration.text = SongDurationUtils.getMinutesStringFromSeconds(duration: duration)
    }
}
