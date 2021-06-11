//
//  Observable+Extension.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 11.06.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
import RxSwift
public extension Observable {
    func handleError() -> Observable<Result<Element, Error>> {
        return self.map { (element) -> Result<Element, Error> in
            return .success(element)
        }.catchError { error -> Observable<Result<Element, Error>> in
            return .just(.failure(error))
        }
    }
}
