//
//  BookmarkViewModel.swift
//  ios decovery
//
//  Created by Ray Chow on 23/5/2023.
//

import Foundation
import RxSwift
import RxCocoa

class BookmarkViewModel: CommonViewModel {
    fileprivate let _onError = PublishSubject<Error>()
    var onError: Observable<Error> { _onError }
    
    fileprivate let stringProvider: StringProvider
    fileprivate let localDatabaseService: LocalDatabaseService
    
    init(stringProvider: StringProvider, localDatabaseService: LocalDatabaseService) {
        self.stringProvider = stringProvider
        self.localDatabaseService = localDatabaseService
    }
}

extension ViewModelInput where ViewModel: BookmarkViewModel {
    
}

extension ViewModelOutput where ViewModel: BookmarkViewModel {
    var tabbarTitle: Driver<String> {
        base.stringProvider.stringObservable(forKey: "main_view_bottom_navigation_item_title_settings").asDriver(onErrorJustReturn: "")
    }
}
