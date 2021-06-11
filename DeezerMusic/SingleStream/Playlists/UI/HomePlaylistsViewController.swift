//
//  HomePlaylistsViewController.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 26.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit
public final class HomePlaylistsViewController: UIViewController, UITableViewDelegate {
    weak var homeNavigationDelegate: HomeNavigationDelegate?
    private let viewModel: HomePlaylistsViewModel!
    var dataSource: RxTableViewSectionedAnimatedDataSource<PlaylistsSectionItem>!
    
    public let tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    private let spinnerView: UIActivityIndicatorView =  {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .red
        return view
    }()
    
    public let disposeBag = DisposeBag()
    
    init(viewModel: HomePlaylistsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.bindDataSource()
        viewModel.input.onNext(.viewDidLoad)
    }

    
}

extension HomePlaylistsViewController {
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubviews(views: [tableView, spinnerView])
        view.bringSubviewToFront(spinnerView)
        setupConstraints()
        self.registerCells()
    }
    
    func setupConstraints(){
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        spinnerView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func registerCells() {
        self.tableView.register(PlaylistCell.self, forCellReuseIdentifier: "PlaylistCell")
        self.tableView.register(NewPlaylistTableViewCell.self, forCellReuseIdentifier: "NewPlaylistTableViewCell")
    }
    
    
    func bindDataSource(){
        disposeBag.insert(viewModel.bindViewModel())
        
        dataSource = RxTableViewSectionedAnimatedDataSource<PlaylistsSectionItem>{ [unowned self] (dataSource, tableView, indexPath, rowItem) -> UITableViewCell in
            let item = dataSource[indexPath.section].items[indexPath.row]
            switch item.cellType{
            case .playlist:
                let safeSongCell: PlaylistCell = tableView.dequeueCell(identifier: "PlaylistCell")
                guard let safeItem = item as? PlaylistsItem else {
                    return UITableViewCell()
                }
                safeSongCell.configureCell(title: safeItem.item.title, numberOfSongs: safeItem.item.songs.count)
                return safeSongCell
            case .newPlaylist:
                let safeNewPLaylistCell: NewPlaylistTableViewCell = tableView.dequeueCell(identifier: "NewPlaylistTableViewCell")
                safeNewPLaylistCell.newPlaylistButton.rx.tap
                    .subscribe(onNext: {
                        let action = UIAlertAction(title: R.string.localizable.create(), style: .default) {[unowned self] _ in
                            viewModel.input.onNext(.newPlaylist(name: viewModel.currentPlaylistName))
                        }
                        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: nil)
                        showAlertWith(title: R.string.localizable.new_playlist(), message: R.string.localizable.new_playlist_name(), handler: { textField in
                            textField.placeholder = R.string.localizable.name()
                            textField.rx.text.changed
                                .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
                                .map( { [unowned self] (text) -> Bool in
                                    viewModel.isPlaylistAvailable(name: text ?? "")
                                })
                                .bind(to: action.rx.isEnabled)
                                .disposed(by: disposeBag)
                                    
                        }, action: action, anotherAction: cancelAction)
                    })
                    .disposed(by: disposeBag)
                safeNewPLaylistCell.backButton.rx
                    .tap
                    .subscribe(onNext: {
                        self.dismiss(animated: true, completion: nil)
                    }).disposed(by: disposeBag)
                return safeNewPLaylistCell
            }
        } canEditRowAtIndexPath: { item, indexPath in
            if indexPath.row == 0 {
                return false
            }else {
                return true
            }
        } canMoveRowAtIndexPath: { _, _ in
            return true
        }
        self.dataSource.animationConfiguration = .init(insertAnimation: .top, reloadAnimation: .fade, deleteAnimation: .automatic)
    
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.output
            .map({ $0.items })
            .bind(to: tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
        viewModel.output
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (output) in
                guard let safeEvent = output.event else { return }
                switch safeEvent{
                case .openDetails(let songs):
                    homeNavigationDelegate?.navigateToSongSingle(type: .playlist(songs))
                case .dismissVC:
                    dismiss(animated: true, completion: nil)
                case .alert:
                    showMessageAlert(title: R.string.localizable.duplicate_song(), message: R.string.localizable.song_already_contained())
                case .error(let message):
                    showMessageAlert(title: R.string.localizable.error(), message: message)
                }
            }).disposed(by: disposeBag)
        
        viewModel.loaderPublisher
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (shouldShowLoader) in
                if shouldShowLoader{
                    spinnerView.startAnimating()
                    spinnerView.isHidden = false
                }else{
                    spinnerView.stopAnimating()
                    spinnerView.isHidden = true
                }
            }).disposed(by: disposeBag)
    
        
        tableView.rx.itemSelected
            .map({ PlaylistsInput.indexSelected(index: $0)})
            .bind(to: viewModel.input)
            .disposed(by: disposeBag)
    }
}
