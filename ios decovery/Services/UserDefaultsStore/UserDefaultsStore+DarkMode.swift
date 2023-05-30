//
//  UserDefaultsStore+DarkMode.swift
//  ios decovery
//
//  Created by Ray Chow on 30/5/2023.
//

import Foundation

private let currentDarkModeKey = "decovery.CurrentDarkMode"

extension UserDefaultsStore {
  var isDarkMode: Bool? {
      get {
          return userDefaults.bool(forKey: currentDarkModeKey)
      }
      set {
          userDefaults.set(newValue, forKey: currentDarkModeKey)
      }
  }
}
