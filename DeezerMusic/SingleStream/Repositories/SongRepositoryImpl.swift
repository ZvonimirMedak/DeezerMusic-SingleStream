//
//  NetworkRepositoryImpl.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 12/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation
import RxSwift

class SongRepositoryImpl: SongRepository{
    let networkManager = NetworkManager()
    
    func getAll(onPage: Int) -> Observable<Result<SongResponse, Error>>{
        let songResponseObservable: Observable<SongResponse> = networkManager.getData(url: "https://api.deezer.com/chart/\(onPage)")
        return songResponseObservable
            .handleError()
    }
}

