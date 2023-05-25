//
//  AppSetting.swift
//  ios decovery
//
//  Created by Ray Chow on 25/5/2023.
//

import Foundation

class LanguageSetting {
    let currentLanguage: Language
    let title: String
    
    init(currentLanguage: Language, title: String) {
        self.currentLanguage = currentLanguage
        self.title = title
    }
}

class DarkModeSetting {
    let isDarkMode: Bool
    let title: String
    
    init(isDarkMode: Bool, title: String) {
        self.isDarkMode = isDarkMode
        self.title = title
    }
}
