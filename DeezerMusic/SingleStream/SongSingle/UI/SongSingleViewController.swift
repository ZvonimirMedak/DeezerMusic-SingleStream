//
//  SongSingleViewController.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 23.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit
public final class SongSingleViewController: UIViewController, UITableViewDelegate {
    weak var songSingleNavigationDelegate: SongSingleNavigationDelegate?
    weak var coordinatorDelegate: CoordinatorDelegate?
    private let viewModel: SongSingleViewModel!
    var dataSource: RxTableViewSectionedAnimatedDataSource<SongSingleSectionItem>!
    
    public let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        let gradientView = GradientView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        gradientView.colors = [.darkGray.withAlphaComponent(1), .darkGray.withAlphaComponent(0.5)]
        gradientView.locations = [0.1, 1.0]
        gradientView.direction = .vertical
        tv.backgroundView = gradientView
        return tv
    }()
    
    private let spinnerView: UIActivityIndicatorView =  {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .red
        return view
    }()
    
    public var disposeBag = DisposeBag()
    
    init(viewModel: SongSingleViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        coordinatorDelegate?.viewControllerHasFinished()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.bindDataSource()
        viewModel.input.onNext(.viewDidLoad)
    }
    
}

extension SongSingleViewController {
    
    private func setupUI() {
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
        self.tableView.register(SongSingleHeaderTableViewCell.self, forCellReuseIdentifier: "SongSingleHeaderTableViewCell")
        self.tableView.register(SongSingleDescriptionTableViewCell.self, forCellReuseIdentifier: "SongSingleDescriptionTableViewCell")
        self.tableView.register(SongSingleAlbumImageTableViewCell.self, forCellReuseIdentifier: "SongSingleAlbumImageTableViewCell")
        self.tableView.register(SongSinglePlayerTableViewCell.self, forCellReuseIdentifier: "SongSinglePlayerTableViewCell")
    }
    
    
    func bindDataSource(){
        disposeBag.insert(viewModel.bindViewModel())
        
        
        dataSource = RxTableViewSectionedAnimatedDataSource<SongSingleSectionItem>{ [unowned self]
            (dataSource, tableView, indexPath, rowItem) -> UITableViewCell in
            let item = dataSource[indexPath.section].items[indexPath.row]
            switch item.cellType{
            case .header(let type):
                let safeHeader: SongSingleHeaderTableViewCell = tableView.dequeueCell(identifier: "SongSingleHeaderTableViewCell")
                guard let safeItem = item as? SongSingleItem else {
                    return UITableViewCell()
                }
                safeHeader.backButton.rx.tap
                    .subscribe(onNext: {[unowned self] in
                        viewModel.input.onNext(.back)
                    })
                    .disposed(by: disposeBag)
                safeHeader.addToPlaylistButton.rx.tap
                    .subscribe(onNext: {[unowned self] in
                        songSingleNavigationDelegate?.navigateToAddToPlaylist(item: safeItem.item)
                    })
                    .disposed(by: disposeBag)
                safeHeader.deletePlaylistButton.rx.tap
                    .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
                    .subscribe(onNext: { [unowned self] in
                        viewModel.input.onNext(.deletePlaylist)
                    }).disposed(by: disposeBag)
                safeHeader.configure(title: safeItem.item.albumName, type: type)
                return safeHeader
            case .albumImage:
                let safeImageCell: SongSingleAlbumImageTableViewCell = tableView.dequeueCell(identifier: "SongSingleAlbumImageTableViewCell")
                guard let safeItem = item as? SongSingleItem else {
                    return UITableViewCell()
                }
                safeImageCell.configure(imageURL: safeItem.item.albumImage)
                return safeImageCell
            case .description(let type):
                let safeDescriptionCell: SongSingleDescriptionTableViewCell = tableView.dequeueCell(identifier: "SongSingleDescriptionTableViewCell")
                guard let safeItem = item as? SongSingleItem else {
                    return UITableViewCell()
                }
                safeDescriptionCell.likeButton.rx.tap
                    .subscribe(onNext: {[unowned self] in
                        viewModel.input.onNext(.likeSong)
                        safeDescriptionCell.likeButton.isSelected = !safeDescriptionCell.likeButton.isSelected
                    })
                    .disposed(by: disposeBag)
                safeDescriptionCell.configure(songTitle: safeItem.item.title, artistName: safeItem.item.artistName, isSelected: safeItem.item.isLiked, type: type)
                return safeDescriptionCell
            case .player:
                let safePlayerCell: SongSinglePlayerTableViewCell = tableView.dequeueCell(identifier: "SongSinglePlayerTableViewCell")
                safePlayerCell.playButton.rx.tap
                    .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
                    .subscribe(onNext: { [unowned self] in
                        safePlayerCell.playButton.isSelected = !safePlayerCell.playButton.isSelected
                        viewModel.input.onNext(.usePlayer())
                        
                    })
                    .disposed(by: disposeBag)
                return safePlayerCell
            case .playlistPlayer:
                let safePlayerCell: SongSinglePlayerTableViewCell = tableView.dequeueCell(identifier: "SongSinglePlayerTableViewCell")
                safePlayerCell.configureCell(isPlaylist: true, isPlaying: viewModel.isPlaying)
                safePlayerCell.playButton.rx.tap
                    .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
                    .subscribe(onNext: { [unowned self] in
                        safePlayerCell.playButton.isSelected = !safePlayerCell.playButton.isSelected
                        viewModel.input.onNext(.usePlayer())
                        
                    })
                    .disposed(by: safePlayerCell.disposeBag)
                safePlayerCell.previousButton.rx.tap
                    .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
                    .subscribe(onNext: { [unowned self] in
                        viewModel.input.onNext(.previousSong)
                        
                    })
                    .disposed(by: safePlayerCell.disposeBag)
                safePlayerCell.skipNextButton.rx.tap
                    .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
                    .subscribe(onNext: { [unowned self] in
                        viewModel.input.onNext(.skipSong)
                        
                    })
                    .disposed(by: safePlayerCell.disposeBag)
                return safePlayerCell
            }
        }
        
        self.dataSource.animationConfiguration = .init(insertAnimation: .left, reloadAnimation: .fade, deleteAnimation: .automatic)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.output
            .map({ $0.items })
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.output
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (output) in
                guard let safeEvent = output.event else { return }
                switch safeEvent{
                case .popController:
                    NotificationCenter.default.removeObserver(self)
                    self.dismiss(animated: true, completion: nil)
                case .newSong:
                    viewModel.input.onNext(.usePlayer(true))
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
            .map({[unowned self] indexPath -> SongSingleInput in
                guard let safeItem = viewModel.output.value.items[indexPath.section].items[indexPath.row] as? SongSingleItem else {return .none}
                switch safeItem.cellType {
                case .player:
                    return .usePlayer()
                default:
                    return .none
                }
            })
            .bind(to: viewModel.input)
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.AVPlayerItemDidPlayToEndTime)
            .observeOn(MainScheduler.instance)
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] _ in
                guard let cell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? SongSinglePlayerTableViewCell else {return}
                cell.playButton.isSelected = false
                viewModel.input.onNext(.songFinished)
            })
            .disposed(by: disposeBag)
    }
}



