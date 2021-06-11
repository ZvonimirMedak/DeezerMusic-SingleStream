//
//  HomeViewModel.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 18.04.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class HomeViewModelImpl: HomeViewModel {
    public var loaderPublisher = PublishSubject<Bool>()
    var input: ReplaySubject<HomeInput> = ReplaySubject.create(bufferSize: 1)
    public var output: BehaviorRelay<HomeOutput> = BehaviorRelay.init(value: HomeOutput(items: [], event: nil))
    
    public struct Dependencies {
        let songRepository: SongRepository
        let likedSongsRepository: LikedSongsRepository
    }
    
    var dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    
}

extension HomeViewModelImpl {
    
    func bindViewModel() -> [Disposable] {
        var disposables = [Disposable]()
        disposables.append(self.input
                            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
                            .flatMap{ [unowned self] (input) -> Observable<HomeOutput> in
                                loaderPublisher.onNext(true)
                                switch input {
                                case .indexSelected(index: let index):
                                    return handleIndexSelection(index)
                                case .newPage:
                                    return handleNewSongPage()
                                case .none:
                                    return Observable.just(HomeOutput(items: self.output.value.items, event: nil))
                                }
                            }.bind(to: output))
        return disposables
    }
    
    func handleNewSongPage() -> Observable<HomeOutput> {
        return Observable.combineLatest(dependencies.likedSongsRepository.getLikedSongIDs(), dependencies.songRepository.getAll(onPage: 0))
            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .flatMap{ [unowned self] (item) -> Observable<HomeOutput> in
                loaderPublisher.onNext(false)
                switch item.1 {
                case .failure(let error):
                    return .just(HomeOutput(items: output.value.items, event: .error(error.localizedDescription)))
                case .success(let response):
                    switch item.0 {
                    case .failure(let error):
                        return .just(HomeOutput(items: output.value.items, event: .error(error.localizedDescription)))
                    case .success(let data):
                        return .just(HomeOutput(items: createScreenData(response.tracks ?? Tracks(data: []), getIDs(data.data() ?? [String: Any]())), event: .none))
                    }
                }
            }
            
    }
    
    func getIDs(_ dict: [String: Any]) -> [SongSingleViewItem] {
        return dict["ids"].map{ item -> [SongSingleViewItem] in
            let safeItems = item as? [[String:Any]]
            return safeItems?.map { newItem -> SongSingleViewItem in
                return SongSingleViewItem(dict: newItem)
            } ?? []
        } ?? []
    }
    
    func handleIndexSelection(_ index: IndexPath) -> Observable<HomeOutput> {
        loaderPublisher.onNext(false)
        guard let safeItem = output.value.items[index.section].items[index.row] as? HomeItem else {
            return Observable.just(HomeOutput(items: output.value.items, event: nil))
        }
        return Observable.just(HomeOutput(items: output.value.items, event: .openDetails(item: safeItem.item)))
    }
    
    func createScreenData(_ songs: Tracks, _ ids: [SongSingleViewItem]) -> [HomeSectionItem] {
        return [HomeSectionItem(identity: "tracks", items: songs.data.map{ (item) -> HomeItem in
            return HomeItem(identity: item.title, cellType: .song, item: SongViewItem(songList: item, isLiked: ids.contains(where: { newItem in
                item.id == newItem.id
            })))
        })]
    }
}

protocol HomeViewModel {
    func bindViewModel() -> [Disposable]
    var loaderPublisher: PublishSubject<Bool> {get}
    var input: ReplaySubject<HomeInput> {get}
    var output: BehaviorRelay<HomeOutput> {get}
}
