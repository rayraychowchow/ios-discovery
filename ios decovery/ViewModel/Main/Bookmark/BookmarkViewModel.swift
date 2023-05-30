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
    private let disposeBag = DisposeBag()
    
    fileprivate let stringProvider: StringProvider
    fileprivate let localDatabaseITunesCollectionType: LocalDatabaseITunesCollectionType
    fileprivate let _onTableViewCellSwiped = PublishSubject<Int>()
    
    fileprivate let bookmarkedCollections: BehaviorRelay<[iTunesCollectionObject]> = BehaviorRelay(value: [])
    fileprivate let _onReload = PublishSubject<Void>()
    
    init(stringProvider: StringProvider, localDatabaseITunesCollectionType: LocalDatabaseITunesCollectionType) {
        self.stringProvider = stringProvider
        self.localDatabaseITunesCollectionType = localDatabaseITunesCollectionType
        
        disposeBag.insert([
            _onTableViewCellSwiped.withUnretained(self).do(onNext: { this, index in
                this.removeCollection(withIndex: index)
            }).subscribe(),
            _onReload.withUnretained(self).do(onNext: { this, _ in
                this.getAllBookmarkedCollections()
            }).subscribe()
        ])
    }
    
    private func removeCollection(withIndex index: Int) {
        let collection = bookmarkedCollections.value[index]
        _ = localDatabaseITunesCollectionType.removeSavedCollection(object: collection)
        _onReload.onNext(())
    }
    
    private func getAllBookmarkedCollections() {
        if let array: [iTunesCollectionObject] = localDatabaseITunesCollectionType.getAllSavedITunesCollection()?.compactMap({ $0 }) {
            bookmarkedCollections.accept(array)
        }
    }
}

extension ViewModelInput where ViewModel: BookmarkViewModel {
    var onTableViewCellSwiped: AnyObserver<Int> {
        base._onTableViewCellSwiped.asObserver()
    }
    
    var onReload: AnyObserver<Void> {
        base._onReload.asObserver()
    }
}

extension ViewModelOutput where ViewModel: BookmarkViewModel {
    var tabbarTitle: Driver<String> {
        base.stringProvider.stringObservable(forKey: "main_view_bottom_navigation_item_title_bookmark").asDriver(onErrorJustReturn: "")
    }
    
    var navigationTitle: Driver<String> {
        base.stringProvider.stringObservable(forKey: "main_view_app_bar_title_bookmarks").asDriver(onErrorJustReturn: "")
    }
    
    var bookmarkedCollections: Observable<[iTunesCollectionObject]> {
        base.bookmarkedCollections.asObservable()
    }
}
