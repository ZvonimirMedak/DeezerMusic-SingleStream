//
//  NewPlaylistTableViewCell.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 26.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
import UIKit
import Rswift
import SnapKit

class NewPlaylistTableViewCell: UITableViewCell {
    let newPlaylistButton: UIButton = {
        let button = UIButton()
        button.setTitle(R.string.localizable.new_playlist().capitalized, for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemTeal
        return button
    }()
    
    public let backButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.dropdown(), for: .normal)
        button.contentMode = .scaleToFill
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NewPlaylistTableViewCell {
    func setupUI(){
        let subviews = [newPlaylistButton, backButton]
        contentView.addSubviews(views: subviews)
        contentView.tintColor = .clear
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        setupConstraints()
    }
    
    func setupConstraints(){
        newPlaylistButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.leading.trailing.equalToSuperview().inset(80)
            make.height.equalTo(45).priority(.high)
        }
        backButton.imageView?.snp.makeConstraints({ make in
            make.width.height.equalTo(25).priority(.high)
        })
        backButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(10)
            make.width.height.equalTo(25).priority(.high)
        }
    }
}
