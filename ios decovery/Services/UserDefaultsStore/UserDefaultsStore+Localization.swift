//
//  UserDefaultsStore+Localization.swift
//  ios decovery
//
//  Created by Ray Chow on 24/5/2023.
//

import Foundation

private let currentLanguageKey = "decovery.CurrentLanguage"

extension UserDefaultsStore {
    var currentLanguage: Language? {
        get {
            if let data = userDefaults.data(forKey: currentLanguageKey) {
                return try? JSONDecoder().decode(Language.self, from: data)
            }
            return nil
        }
        set {
            if let data = (try? JSONEncoder().encode(newValue)) {
                userDefaults.setValue(data, forKey: currentLanguageKey)
            }
        }
    }
}
