//
//  HomePlaylistsViewModel.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 26.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Rswift

enum PlaylistType: Equatable {
    case playlists
    case addToPlaylist(song: SongSingleViewItem)
}

public class HomePlaylistsViewModelImpl: HomePlaylistsViewModel {
    public var loaderPublisher = PublishSubject<Bool>()
    var input: ReplaySubject<PlaylistsInput> = ReplaySubject.create(bufferSize: 1)
    public var output: BehaviorRelay<PlaylistsOutput> = BehaviorRelay.init(value: PlaylistsOutput(items: [], event: nil))
    public var currentPlaylistName: String = ""
    
    public struct Dependencies {
        let playlistsRepository: PlaylistsRepository
        let likedSongsRepository: LikedSongsRepository
        let playlistType: PlaylistType
    }
    
    var dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func isPlaylistAvailable(name: String) -> Bool {
        let safeItems = output.value.items.first?.items as? [PlaylistsItem]
        currentPlaylistName = name
        return safeItems?.contains(where: { item in
            item.item.title.lowercased() != name.lowercased() && name.lowercased() != "liked"
        }) ?? false ? true : false
    }
}

extension HomePlaylistsViewModelImpl {
    
    func bindViewModel() -> [Disposable] {
        var disposables = [Disposable]()
        disposables.append(self.input
                            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
                            .flatMap{ [unowned self] (input) -> Observable<PlaylistsOutput> in
                                loaderPublisher.onNext(true)
                                switch input {
                                case .newPlaylist(name: let name):
                                    return handleNewPlaylistCreation(name)
                                case .indexSelected(index: let index):
                                    return handleIndexSelection(index)
                                case .viewDidLoad:
                                    return handleViewDidLoad()
                                case .none:
                                    return Observable.just(PlaylistsOutput(items: self.output.value.items, event: nil))
                                }
                            }.bind(to: output))
        return disposables
    }
    
    func handleNewPlaylistCreation(_ name: String) -> Observable<PlaylistsOutput> {
        switch dependencies.playlistType {
        case .playlists:
            loaderPublisher.onNext(false)
            return .just(PlaylistsOutput(items: output.value.items, event: nil))
        case .addToPlaylist(let song):
            return dependencies.playlistsRepository
                .addNewPlaylist(songItem: song, playlistName:  name)
                .flatMap{ [unowned self] _  -> Observable<PlaylistsOutput> in
                    loaderPublisher.onNext(false)
                    return .just(PlaylistsOutput(items: output.value.items, event: .dismissVC))
                }
        }
        
    }
    
    func handleIndexSelection(_ index: IndexPath) -> Observable<PlaylistsOutput> {
        loaderPublisher.onNext(false)
        guard let safeItem = output.value.items[index.section].items[index.row] as? PlaylistsItem else {
            return Observable.just(PlaylistsOutput(items: output.value.items, event: nil))
        }
        switch dependencies.playlistType {
        case .addToPlaylist(let song):
            let item = output.value.items[index.section].items[index.row] as? PlaylistsItem
            if item?.item.songs.contains(where: { songItem in
                songItem.id == song.id
            }) ?? false{
                return .just(PlaylistsOutput(items: output.value.items, event: .alert))
            }
            return dependencies.playlistsRepository.addToPlaylist(song: song, playlistName: safeItem.item.title)
                .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
                .flatMap{ [unowned self] _  -> Observable<PlaylistsOutput> in
                    .just(PlaylistsOutput(items: output.value.items, event: .dismissVC))
                }
        case .playlists:
            return .just(PlaylistsOutput(items: output.value.items, event: .openDetails(songs: safeItem.item)))
        }
    }
    
    func handleViewDidLoad() -> Observable<PlaylistsOutput> {
        return Observable.combineLatest(dependencies.likedSongsRepository.getLikedSongIDs(), dependencies.playlistsRepository.getAllPlaylists())
            .flatMap{ [unowned self] (items) -> Observable<PlaylistsOutput> in
                switch items.0 {
                case .failure(let error):
                    return .just(PlaylistsOutput(items: output.value.items, event: .error(error.localizedDescription)))
                case .success(let likedData):
                    switch items.1 {
                    case .failure(let error):
                        return .just(PlaylistsOutput(items: output.value.items, event: .error(error.localizedDescription)))
                    case .success(let playlistsData):
                        guard let safeLikedSongs = likedData.data(), let safeItems = playlistsData.data() else {
                            return .just(PlaylistsOutput(items: output.value.items, event: .error("No items")))
                        }
                        return .just(PlaylistsOutput(items: createScreenData(safeLikedSongs, safeItems), event: nil))
                    }
                }
                
            }
    }
    
    func createScreenData(_ likedSongs: [String: Any], _ playlists: [String: Any]) -> [PlaylistsSectionItem] {
        var playlistItems = [PlaylistsItem]()
        switch dependencies.playlistType {
        case .addToPlaylist(_):
            playlistItems.append(PlaylistsItem(identity: "addNewPlaylist", cellType: .newPlaylist, item: PlaylistsViewItem(songs: [], title: "")))
        case .playlists:
            if let safeSongs = likedSongs["ids"] as? [[String: Any]] {
                playlistItems.append(PlaylistsItem(identity: "likedSongs", cellType: .playlist, item: PlaylistsViewItem(songs: safeSongs.map{ (item) -> SongSingleViewItem in
                    return SongSingleViewItem(dict: item)
                }, title: "Liked")))
            }
            
        }
        playlistItems.append(contentsOf: getPlaylists(playlists))
        loaderPublisher.onNext(false)
        return [PlaylistsSectionItem(identity: "playlists", items: playlistItems)]

    }
    
    func getPlaylists(_ playlists: [String: Any]) -> [PlaylistsItem] {
        return playlists.keys.map{ (item) -> PlaylistsItem in
            guard let value = playlists[item] as? [[String: Any]] else {
                return PlaylistsItem(identity: "", cellType: .playlist, item: PlaylistsViewItem(songs: [], title: ""))
            }
            return PlaylistsItem(identity: item , cellType: .playlist, item: PlaylistsViewItem(songs: value.map{ (song) -> SongSingleViewItem in
                SongSingleViewItem(dict: song)
            }, title: item))
        }
    }
}

protocol HomePlaylistsViewModel {
    func bindViewModel() -> [Disposable]
    var loaderPublisher: PublishSubject<Bool> {get}
    var input: ReplaySubject<PlaylistsInput> {get}
    var output: BehaviorRelay<PlaylistsOutput> {get}
    var currentPlaylistName: String {get}
    func isPlaylistAvailable(name: String) -> Bool
}
