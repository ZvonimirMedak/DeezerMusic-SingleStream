//
//  LikedSongsRepository.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 25.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import RxFirebaseFirestore
import RxSwift
class LikedSongsRepositoryImpl: LikedSongsRepository {
    let db = Firestore.firestore()
    func getLikedSongIDs() -> Observable<Result<DocumentSnapshot, Error>> {
        return db.collection("playlists")
            .document("liked")
            .rx
            .listen()
            .handleError()
    }
    
    func addLikedSong(songSingleViewItem: SongSingleViewItem) -> Observable<Result<Void, Error>> {
        return db.collection("playlists")
            .document("liked")
            .rx
            .getDocument()
            .flatMap{ (item) -> Observable<[[String:Any]]> in
                return .just(item.data()?["ids"] as? [[String:Any]] ?? [])
            }.flatMap{ [unowned self] (items) -> Observable<Void> in
                var newItems = items
                newItems.append(songSingleViewItem.toDict())
                return db.collection("playlists")
                    .document("liked")
                    .rx
                    .setData([
                        "ids": newItems
                    ])
            }
            .handleError()
    }
    
    func removeLikedSong(id: Int) -> Observable<Result<Void, Error>> {
        return db.collection("playlists")
            .document("liked")
            .rx
            .getDocument()
            .flatMap{ (item) -> Observable<[[String:Any]]> in
                return .just(item.data()?["ids"] as? [[String:Any]] ?? [])
            }.flatMap{ [unowned self] (items) -> Observable<Void> in
                var newItems = items
                newItems.removeAll { item in
                    let safeItem = SongSingleViewItem(dict: item)
                    return safeItem.id == id
                }
                
                return db.collection("playlists")
                    .document("liked")
                    .rx
                    .setData([
                        "ids": newItems
                    ])
            }
            .handleError()
    }
}

protocol LikedSongsRepository {
    func getLikedSongIDs() -> Observable<Result<DocumentSnapshot, Error>>
    func addLikedSong(songSingleViewItem: SongSingleViewItem) ->Observable<Result<Void, Error>>
    func removeLikedSong(id: Int) -> Observable<Result<Void, Error>>
}
