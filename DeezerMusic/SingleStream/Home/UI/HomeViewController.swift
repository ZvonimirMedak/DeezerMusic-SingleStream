//
//  HomeViewController.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 20.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit
public final class HomeViewController: UIViewController, UITableViewDelegate {
    weak var homeNavigationDelegate: HomeNavigationDelegate?
    private let viewModel: HomeViewModel!
    var dataSource: RxTableViewSectionedAnimatedDataSource<HomeSectionItem>!
    
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
    
    init(viewModel: HomeViewModel) {
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
        viewModel.input.onNext(.newPage)
    }

    
}

extension HomeViewController {
    
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
        self.tableView.register(SongTableViewCell.self, forCellReuseIdentifier: "SongTableViewCell")
    }
    
    
    func bindDataSource(){
        disposeBag.insert(viewModel.bindViewModel())
        
        dataSource = RxTableViewSectionedAnimatedDataSource<HomeSectionItem>{ (dataSource, tableView, indexPath, rowItem) -> UITableViewCell in
            let item = dataSource[indexPath.section].items[indexPath.row]
            switch item.cellType{
            case .song:
                let safeSongCell: SongTableViewCell = tableView.dequeueCell(identifier: "SongTableViewCell")
                guard let safeItem = item as? HomeItem else {
                    return UITableViewCell()
                }
                
                safeSongCell.configure(title: safeItem.item.title, albumURL: safeItem.item.album.cover, artistURL: safeItem.item.artist.picture, duration: safeItem.item.duration, albumName: safeItem.item.album.title, artist: safeItem.item.artist.name)
                return safeSongCell
            }
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
                case .popController:
                    self.navigationController?.popViewController(animated: true)
                case .openDetails(let item):
                    homeNavigationDelegate?.navigateToSongSingle(type: .song(item))
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
            .map({ HomeInput.indexSelected(index: $0)})
            .bind(to: viewModel.input)
            .disposed(by: disposeBag)
    }
}


