//
//  SongSinglePlayerTableViewCell.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 23.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class SongSinglePlayerTableViewCell: UITableViewCell{
    
    public var disposeBag = DisposeBag()
    
    public let playButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.play(), for: .normal)
        button.setImage(R.image.pause(), for: .selected)
        return button
    }()
    
    public let previousButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.previous(), for: .normal)
        button.isHidden = true
        return button
    }()
    
    public let skipNextButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(R.image.skipNext(), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(isPlaylist: Bool, isPlaying: Bool) {
        if isPlaying {
            playButton.isSelected = true
        }
        if isPlaylist {
            previousButton.isHidden = false
            skipNextButton.isHidden = false
        }
        previousButton.isHidden = false
        skipNextButton.isHidden = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func setupUI(){
        let subviews = [playButton, skipNextButton, previousButton]
        contentView.addSubviews(views: subviews)
        selectionStyle = .none
        contentView.tintColor = .clear
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        setupConstraints()
    }
    
    private func setupConstraints(){
        playButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(36)
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        previousButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.height.width.equalTo(36)
            make.top.bottom.equalTo(playButton)
        }
        
        skipNextButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.height.width.equalTo(36)
            make.top.bottom.equalTo(playButton)
        }
    }
}
