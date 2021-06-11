//
//  SongSingleDescriptionTableViewCell.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 23.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SongSingleDescriptionTableViewCell: UITableViewCell{
    let songTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        StyleManager.shared.apply(label: label)
        return label
    }()
    let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        StyleManager.shared.apply(label: label)
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.favorite(), for: .selected)
        button.setImage(R.image.not_favorite(), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        let subviews = [artistNameLabel, songTitleLabel, likeButton]
        contentView.addSubviews(views: subviews)
        selectionStyle = .none
        contentView.tintColor = .clear
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        setupConstraints()
    }
    
    private func setupConstraints(){
        songTitleLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(30)
        }
        artistNameLabel.snp.makeConstraints { make in
            make.top.equalTo(songTitleLabel.snp.bottom).inset(-8)
            make.leading.trailing.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 30, bottom: 20, right: 0))
        }
        likeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    func configure(songTitle: String, artistName: String, isSelected: Bool, type: SongSingleType){
        switch type {
        case .playlist(_):
            likeButton.isHidden = true
        default:
            likeButton.isHidden = false
        }
        songTitleLabel.text = songTitle
        artistNameLabel.text = artistName
        likeButton.isSelected = isSelected
    }
}
