//
//  DecoderManager.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 12/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation

class DecoderManager{
    static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    public static func parseData<T: Codable>(jsonData: Data) -> T?{
        let object: T?
        do {
            object = try jsonDecoder.decode(T.self, from: jsonData)
            
        }catch let error {
            debugPrint("Error while parsing data from server. Received dataClassType: \(T.self). More info: \(error)")
            object=nil
        }
        return object
    }
}
