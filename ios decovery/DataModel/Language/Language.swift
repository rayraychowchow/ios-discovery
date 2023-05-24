//
//  Language.swift
//  ios decovery
//
//  Created by Ray Chow on 24/5/2023.
//

import Foundation
public enum Language: String, Codable, CaseIterable {
    case en, zh_hk
}

public extension Language {
    var locale: Locale {
        switch self {
        case .en:
            return Locale(identifier: "en_US_POSIX")
        case .zh_hk:
            return Locale(identifier: "yue_Hant_HK")
        }
    }
}
