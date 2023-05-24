//
//  AlbumViewModel.swift
//  ios decovery
//
//  Created by Ray Chow on 23/5/2023.
//

import Foundation
import RxSwift

class AlbumViewModel: CommonViewModel {
    fileprivate let _onError = PublishSubject<Error>()
    var onError: Observable<Error> { _onError }
    
    private let networkService: NetworkService
    private let localDatabaseService: LocalDatabaseService
    
    init(networkService: NetworkService, localDatabaseService: LocalDatabaseService) {
        self.networkService = networkService
        self.localDatabaseService = localDatabaseService
    }
}

extension ViewModelInput where ViewModel: AlbumViewModel {
    
}

extension ViewModelOutput where ViewModel: AlbumViewModel {
   
}
