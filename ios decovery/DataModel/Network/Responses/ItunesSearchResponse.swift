//
//  ItunesSearchResponse.swift
//  ios decovery
//
//  Created by Ray Chow on 29/5/2023.
//

import Foundation

// A generic response for iTunes Search
struct ItunesSearchResponse: Decodable {
    var resultCount: Int
    var results: [iTunesCollection]
}
