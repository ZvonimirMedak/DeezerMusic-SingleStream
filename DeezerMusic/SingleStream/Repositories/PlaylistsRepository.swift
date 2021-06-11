//
//  PlaylistsRepository.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 26.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
import RxFirebaseFirestore
import FirebaseFirestoreSwift
import RxSwift
import FirebaseFirestore

class PlaylistsRepositoryImpl: PlaylistsRepository {
    func removePlaylist(playlistName: String) -> Observable<Result<Void, Error>> {
        db.collection("playlists")
            .document("userPlaylists")
            .rx
            .getDocument()
            .flatMap{ [unowned self] (item) -> Observable<()> in
                var itemToChange = item.data() ?? [:]
                itemToChange[playlistName] = nil
                return db.collection("playlists")
                    .document("userPlaylists")
                    .rx
                    .setData(itemToChange)
            }
            .handleError()
    }
    
    let db = Firestore.firestore()
    func getAllPlaylists() -> Observable<Result<DocumentSnapshot, Error>> {
        return db.collection("playlists")
            .document("userPlaylists")
            .rx
            .listen()
            .handleError()
    }
    
    func addNewPlaylist(songItem: SongSingleViewItem, playlistName: String) -> Observable<Result<Void, Error>> {
        return db.collection("playlists")
            .document("userPlaylists")
            .rx
            .getDocument()
            .flatMap{ [unowned self] (item) -> Observable<()> in
                var itemToChange = item.data() ?? [:]
                itemToChange[playlistName] = [songItem.toDict()]
                return db.collection("playlists")
                    .document("userPlaylists")
                    .rx
                    .setData(itemToChange)
            }
            .handleError()
    }
    
    func addToPlaylist(song: SongSingleViewItem, playlistName: String) -> Observable<Result<Void, Error>> {
        return db.collection("playlists")
            .document("userPlaylists")
            .rx
            .getDocument()
            .flatMap{ [unowned self] (item) -> Observable<Void> in
                guard let safeItem = item.data()?[playlistName] as? [[String:Any]] else {
                    return .just(())
                }
                var newItems = safeItem
                newItems.append(song.toDict())
                return db.collection("playlists")
                    .document("userPlaylists")
                    .rx
                    .updateData([playlistName : newItems])
            }
            .handleError()
    }
}


protocol PlaylistsRepository {
    func getAllPlaylists() -> Observable<Result<DocumentSnapshot, Error>>
    func addNewPlaylist(songItem: SongSingleViewItem, playlistName: String) -> Observable<Result<Void, Error>>
    func addToPlaylist(song: SongSingleViewItem, playlistName: String) -> Observable<Result<Void, Error>>
    func removePlaylist(playlistName: String) -> Observable<Result<Void, Error>>
}
