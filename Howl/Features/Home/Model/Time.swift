//
//  Time.swift
//  Howl
//
//  Created by Roshani Ayu Pranasti on 02/05/21.
//

import Foundation

struct Time {
    var name: String?
    var duration: Int?
    
    init(timeName: String, timeDuration: Int) {
        name = timeName
        duration = timeDuration
    }
}
