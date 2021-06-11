//
//  NetworkManager.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 12/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class NetworkManager{
    func getData<T: Codable>(url: String) -> Observable<T>{
        var parameters = Parameters()
        parameters["apiid"] = "a2f3e00b8a167891f601307dd4ffe5ef"
        
        return Observable.create{ observer in
           let request = AF.request(url, parameters: parameters).validate().responseDecodable(of: T.self, decoder: DecoderManager.jsonDecoder){ networkResponse in
                switch networkResponse.result{
                case .success:
                    do{
                        let response = try networkResponse.result.get()
                        observer.onNext(response)
                        observer.onCompleted()
                    }
                    catch(let error){
                        observer.onError(error)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
