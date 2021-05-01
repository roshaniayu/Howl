//
//  UserDefaults.swift
//  Howl
//
//  Created by Roshani Ayu Pranasti on 01/05/21.
//

import Foundation

extension UserDefaults {
    func setValueLoad(value: Bool?) {
        if value != nil {
            UserDefaults.standard.set(value, forKey: "code")
        } else {
            UserDefaults.standard.removeObject(forKey: "code")
        }
        UserDefaults.standard.synchronize()
    }
    
    func getValueLoad() -> Bool? {
        return UserDefaults.standard.value(forKey: "code") as? Bool
    }
}
