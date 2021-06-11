//
//  SongSingleHeaderTableViewCell.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 23.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SongSingleHeaderTableViewCell: UITableViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        StyleManager.shared.apply(label: label)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    public let backButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.dropdown(), for: .normal)
        button.contentMode = .scaleToFill
        return button
    }()
    
    public let addToPlaylistButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.plus(), for: .normal)
        return button
    }()
    
    public let deletePlaylistButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.delete(), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, type: SongSingleType){
        let attributedString = NSMutableAttributedString(string: R.string.localizable.you_are_listening(), attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)])
        attributedString.append(NSAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]))
        titleLabel.attributedText = attributedString
        switch type {
        case .playlist(let playlist):
            addToPlaylistButton.isHidden = true
            if playlist.title != R.string.localizable.liked() {
                deletePlaylistButton.isHidden = false
            }else {
                deletePlaylistButton.isHidden = true
            }
            
        default:
            addToPlaylistButton.isHidden = false
            deletePlaylistButton.isHidden = true
        }
    }
}

private extension SongSingleHeaderTableViewCell {
    func setupUI(){
        let subviews = [titleLabel, backButton, addToPlaylistButton, deletePlaylistButton]
        contentView.addSubviews(views: subviews)
        contentView.tintColor = .clear
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        setupConstraints()
    }
    
    func setupConstraints(){
        titleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        backButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(10)
            make.width.height.equalTo(25).priority(.high)
        }
        backButton.imageView?.snp.makeConstraints({ make in
            make.width.height.equalTo(25).priority(.high)
        })
        addToPlaylistButton.snp.makeConstraints { make in
            make.width.height.equalTo(25)
            make.trailing.top.equalToSuperview().inset(10)
        }
        deletePlaylistButton.snp.makeConstraints { make in
            make.width.height.equalTo(25)
            make.trailing.top.equalToSuperview().inset(10)
        }
    }
}
