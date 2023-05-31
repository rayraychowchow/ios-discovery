//
//  NetworkService+ITunesSearchAPIType.swift
//  ios decovery
//
//  Created by Ray Chow on 29/5/2023.
//

import Foundation
import RxSwift
import Alamofire

extension NetworkService: ITunesSearchAPIType {
    func forITunesSearch(term: String) -> Single<ItunesSearchResponse> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return getDecodableReponse(url: "https://itunes.apple.com/search",
                         params: ["term": term, "entity": "album"], encoding: URLEncoding.default, dateFormatter: dateFormatter)

    }
}
