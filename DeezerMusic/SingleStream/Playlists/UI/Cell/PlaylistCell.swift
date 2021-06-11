//
//  PlaylistListCell.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 13/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class PlaylistCell: UITableViewCell{
    
    let playlistTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    let numberOfSongsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
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
        let subviews = [playlistTitleLabel, numberOfSongsLabel]
        contentView.addSubviews(views: subviews)
        selectionStyle = .none
        setupConstraints()
    }
    
    private func setupConstraints(){
        playlistTitleLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(10)
        }
        numberOfSongsLabel.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview().inset(10)
            make.top.equalTo(playlistTitleLabel.snp.bottom).inset(-5)
        }
    }
    
    func configureCell(title: String, numberOfSongs: Int){
        playlistTitleLabel.text = title
        numberOfSongsLabel.text = String(numberOfSongs)
    }
    

}
