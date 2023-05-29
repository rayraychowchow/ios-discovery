//
//  ITunesSearchAPI.swift
//  ios decovery
//
//  Created by Ray Chow on 29/5/2023.
//

import Foundation
import RxSwift

protocol ITunesSearchAPIType {
    func forITunesSearch(term: String) -> Single<ItunesSearchResponse>
}

