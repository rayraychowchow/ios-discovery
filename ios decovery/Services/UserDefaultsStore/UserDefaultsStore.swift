//
//  UserDefaultService.swift
//  ios decovery
//
//  Created by Ray Chow on 23/5/2023.
//

import Foundation
class UserDefaultsStore {
    static let shared: UserDefaultsStore = UserDefaultsStore()
    
    let userDefaults = UserDefaults.standard
}
