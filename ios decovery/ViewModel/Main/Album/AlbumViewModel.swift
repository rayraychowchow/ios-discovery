//
//  AlbumViewModel.swift
//  ios decovery
//
//  Created by Ray Chow on 23/5/2023.
//

import Foundation
import RxSwift
import RxCocoa

class AlbumViewModel: CommonViewModel {
    fileprivate let _onError = PublishSubject<Error>()
    var onError: Observable<Error> { _onError }
    
    let stringProvider: StringProvider
    private let networkService: NetworkService
    private let localDatabaseService: LocalDatabaseService
    
    init(stringProvider: StringProvider, networkService: NetworkService, localDatabaseService: LocalDatabaseService) {
        self.stringProvider = stringProvider
        self.networkService = networkService
        self.localDatabaseService = localDatabaseService
    }
}

extension ViewModelInput where ViewModel: AlbumViewModel {
    
}

extension ViewModelOutput where ViewModel: AlbumViewModel {    
    var tabbarTitle: Driver<String> {
        base.stringProvider.stringObservable(forKey: "main_view_bottom_navigation_item_title_albums").asDriver(onErrorJustReturn: "")
    }
}
