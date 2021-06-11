//
//  SongSingleViewModel.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 23.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import AVFoundation
public enum SongSingleType: Equatable {
    case song(_ song: SongViewItem)
    case playlist(_ playlist: PlaylistsViewItem)
}

public class SongSingleViewModelImpl: SongSingleViewModel {
    public var loaderPublisher = PublishSubject<Bool>()
    private var avPlayer: AVPlayer?
    var input: ReplaySubject<SongSingleInput> = ReplaySubject.create(bufferSize: 1)
    public var output: BehaviorRelay<SongSingleOutput> = BehaviorRelay.init(value: SongSingleOutput(items: [], event: nil))
    public var isPlaying = false
    private var isLiked = false
    private var itemNumber = 0
    
    public struct Dependencies {
        let songSingleType: SongSingleType
        let likedSongsRepository: LikedSongsRepository
        let playlistsRepository: PlaylistsRepository
    }
    
    
    var dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    
}

extension SongSingleViewModelImpl {
    
    func bindViewModel() -> [Disposable] {
        var disposables = [Disposable]()
        disposables.append(self.input
                            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
                            .flatMap{ [unowned self] (input) -> Observable<SongSingleOutput> in
                                loaderPublisher.onNext(true)
                                switch input {
                                case .likeSong:
                                    return handleLikeSong()
                                case .songFinished:
                                    return handleSongFinished()
                                case .usePlayer(let finishedSong):
                                    return handleAVPlayer(finishedSong: finishedSong)
                                case .viewDidLoad:
                                    return handleViewDidLoad()
                                case .back:
                                    return handleBack()
                                case .none:
                                    loaderPublisher.onNext(false)
                                    return .just(SongSingleOutput(items: output.value.items, event: nil))
                                case .skipSong:
                                    return handleNextSong(true)
                                case .previousSong:
                                    return handleNextSong(false)
                                case .deletePlaylist:
                                    return handleRemovePlaylist()
                                }
                            }.bind(to: output))
        return disposables
    }
    
    func handleLikeSong() -> Observable<SongSingleOutput> {
        guard let safeItem = output.value.items.first?.items.first as? SongSingleItem else {
            return .just(SongSingleOutput(items: output.value.items, event: nil))
        }
        let observable =  isLiked ? dependencies.likedSongsRepository.removeLikedSong(id: safeItem.item.id) : dependencies.likedSongsRepository.addLikedSong(songSingleViewItem: safeItem.item)
        isLiked = !isLiked
        return observable
            .flatMap{ [unowned self] (_) -> Observable<SongSingleOutput> in
                loaderPublisher.onNext(false)
                return .just(SongSingleOutput(items: output.value.items, event: .none))
            }
            
    }
    
    func handleBack() -> Observable<SongSingleOutput> {
        avPlayer = nil
        loaderPublisher.onNext(false)
        return Observable.just(SongSingleOutput(items: output.value.items, event: .popController))
    }
    
    func handleNextSong(_ isSkip: Bool) -> Observable<SongSingleOutput> {
        avPlayer?.pause()
        avPlayer = nil
        loaderPublisher.onNext(false)
        switch dependencies.songSingleType {
        case .playlist(let playlist):
            isPlaying = true
            let songCount = playlist.songs.count
            if isSkip {
                itemNumber += 1
                itemNumber = itemNumber == songCount ? 0 : itemNumber
            }else{
                itemNumber -= 1
                itemNumber = itemNumber == -1 ? songCount - 1 : itemNumber
            }
            
            return .just(SongSingleOutput(items: [SongSingleSectionItem(identity: playlist.songs[itemNumber].title, items: createPlaylistScreenData(playlist))], event: .newSong))
        default:
            return .just(SongSingleOutput(items: output.value.items, event: nil))
        }
    }
    
    func handleAVPlayer(finishedSong: Bool = false) -> Observable<SongSingleOutput> {
        var url: URL? = nil
        switch dependencies.songSingleType {
        case .song(let song):
            url = URL(string: song.songPreviewURL)
        case .playlist(let item):
            url = URL(string: item.songs[itemNumber].songPreviewURL)
        }
        guard let safeURL = url else {return .just(SongSingleOutput(items: output.value.items, event: nil))}
        if !finishedSong {
            isPlaying = !isPlaying
        }
        isPlaying ? avPlayer?.play() : avPlayer?.pause()
        if avPlayer == nil {
            let avPlayerItem = AVPlayerItem(url: safeURL)
            avPlayer = AVPlayer(playerItem: avPlayerItem)
            isPlaying = true
            avPlayer?.play()
        }
        loaderPublisher.onNext(false)
        return .just(SongSingleOutput(items: output.value.items, event: .none))
    }
    
    func handleSongFinished() -> Observable<SongSingleOutput> {
        switch dependencies.songSingleType {
        case .playlist(_):
            return handleNextSong(true)
        default:
            avPlayer = nil
            isPlaying = false
        }
        
        loaderPublisher.onNext(false)
        return .just(SongSingleOutput(items: output.value.items, event: .none))
    }
 
    func handleViewDidLoad() -> Observable<SongSingleOutput> {
        switch dependencies.songSingleType {
        case .song(let song):
            return .just(SongSingleOutput(items: [SongSingleSectionItem(identity: song.title, items: createSongScreenData(song))], event: nil))
        case .playlist(let playlist):
            return .just(SongSingleOutput(items: [SongSingleSectionItem(identity: playlist.songs[itemNumber].title, items: createPlaylistScreenData(playlist))], event: nil))
        }
    }
    
    func createSongScreenData(_ song: SongViewItem) -> [SongSingleItem] {
        isLiked = song.liked
        var items = [SongSingleItem]()
        items.append(SongSingleItem(identity: "header", cellType: .header(type: dependencies.songSingleType), item: SongSingleViewItem(songItem: song)))
        items.append(SongSingleItem(identity: "image", cellType: .albumImage, item: SongSingleViewItem(songItem: song)))
        items.append(SongSingleItem(identity: "description", cellType: .description(type: dependencies.songSingleType), item: SongSingleViewItem(songItem: song)))
        items.append(SongSingleItem(identity: "player", cellType: .player, item: SongSingleViewItem(songItem: song)))
        loaderPublisher.onNext(false)
        return items
    }
    
    func createPlaylistScreenData(_ playlist: PlaylistsViewItem) -> [SongSingleItem] {
        let currentSong = playlist.songs[itemNumber]
        var items = [SongSingleItem]()
        items.append(SongSingleItem(identity: "header", cellType: .header(type: dependencies.songSingleType), item: currentSong))
        items.append(SongSingleItem(identity: "image", cellType: .albumImage, item: currentSong))
        items.append(SongSingleItem(identity: "description", cellType: .description(type: dependencies.songSingleType), item: currentSong))
        items.append(SongSingleItem(identity: "player", cellType: .playlistPlayer, item: currentSong))
        loaderPublisher.onNext(false)
        return items
    }
    
    func handleRemovePlaylist() -> Observable<SongSingleOutput> {
        loaderPublisher.onNext(false)
        switch dependencies.songSingleType {
        case .playlist(let playlist):
            return dependencies.playlistsRepository.removePlaylist(playlistName: playlist.title)
                .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
                .flatMap{[unowned self] _ -> Observable<SongSingleOutput> in
                    return handleBack()
                }
        default:
            return .just(SongSingleOutput(items: output.value.items, event: nil))
        }
        
    }
}

protocol SongSingleViewModel {
    func bindViewModel() -> [Disposable]
    var loaderPublisher: PublishSubject<Bool> {get}
    var input: ReplaySubject<SongSingleInput> {get}
    var output: BehaviorRelay<SongSingleOutput> {get}
    var isPlaying: Bool {get}
}
