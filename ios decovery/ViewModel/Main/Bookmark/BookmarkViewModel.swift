//
//  BookmarkViewModel.swift
//  ios decovery
//
//  Created by Ray Chow on 23/5/2023.
//

import Foundation
import RxSwift

class BookmarkViewModel: CommonViewModel {
    fileprivate let _onError = PublishSubject<Error>()
    var onError: Observable<Error> { _onError }
    
    private let localDatabaseService: LocalDatabaseService
    
    init(localDatabaseService: LocalDatabaseService) {
        self.localDatabaseService = localDatabaseService
    }
}

extension ViewModelInput where ViewModel: BookmarkViewModel {
    
}

extension ViewModelOutput where ViewModel: BookmarkViewModel {
   
}
