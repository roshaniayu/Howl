//
//  Time.swift
//  Howl
//
//  Created by Roshani Ayu Pranasti on 02/05/21.
//

import Foundation

enum TimeType: String {
    case fiveMins = "5 mins"
    case tenMins = "10 mins"
    case fifteenMins = "15 mins"
    case thirtyMins = "30 mins"
    case fortyfiveMins = "45 mins"
    case oneHour = "1 hour"
}

struct Time {
    var type: TimeType?
    var name: String?
    var duration: Int?
    
    init(timeType: TimeType, timeName: String, timeDuration: Int) {
        type = timeType
        name = timeName
        duration = timeDuration
    }
}
