//
//  NetworkRepository.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 12/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation
import RxSwift

protocol SongRepository{
    func getAll(onPage: Int) -> Observable<Result<SongResponse, Error>>
}
