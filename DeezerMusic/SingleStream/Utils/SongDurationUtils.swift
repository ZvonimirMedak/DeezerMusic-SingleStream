//
//  DurationUtils.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 12/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation
class SongDurationUtils{
    static func getMinutesStringFromSeconds(duration: Int) -> String{
        var minutes = 0
        var seconds = duration
        while(seconds > 60){
            seconds -= 60
            minutes += 1
        }
        var durationString = "\(minutes):"
        if seconds < 10 {
            durationString.append("0\(seconds)")
        }
        else{
            durationString.append("\(seconds)")
        }
        return durationString
    }
}
