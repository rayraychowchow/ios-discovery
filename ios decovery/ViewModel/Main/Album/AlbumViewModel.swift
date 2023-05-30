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
    
    private let disposeBag = DisposeBag()
    
    fileprivate let stringProvider: StringProvider
    fileprivate let iTunesSearchAPIType: ITunesSearchAPIType
    fileprivate let localDatabaseITunesCollectionType: LocalDatabaseITunesCollectionType
    fileprivate let albumCoordinatorType: AlbumCoordinatorType
    
    fileprivate let _onCollectionTapped = PublishSubject<Int>()
    fileprivate let _onReload = PublishSubject<Void>()
    fileprivate let _onBookmarkButtonTapped = PublishSubject<Int>()
    fileprivate let _onSearchTextChanged = PublishSubject<String>()
    
    fileprivate let _iTunesData = BehaviorRelay<[iTunesCollection]>(value: [])
    fileprivate let _iTunesCollectionLocalData = BehaviorRelay<[iTunesCollectionObject]>(value: [])
    
    init(albumCoordinatorType: AlbumCoordinatorType, stringProvider: StringProvider, iTunesSearchAPIType: ITunesSearchAPIType, localDatabaseITunesCollectionType: LocalDatabaseITunesCollectionType) {
        self.albumCoordinatorType = albumCoordinatorType
        self.stringProvider = stringProvider
        self.iTunesSearchAPIType = iTunesSearchAPIType
        self.localDatabaseITunesCollectionType = localDatabaseITunesCollectionType
        
        disposeBag.insert([
            _onCollectionTapped.withUnretained(self).do { this, index in
                let collection = this._iTunesData.value[index]
                this.albumCoordinatorType.presentAlbumDetailsView(collection: collection, isBookMarked:  this._iTunesCollectionLocalData.value.contains(where: { $0.collectionViewUrl == collection.collectionViewUrl }))
            }.subscribe(),
            _onReload.withUnretained(self).do(onNext: { this, _ in
                this.getBookmarkedITunesCollectionFromLocal()
            }).subscribe(),
            _onBookmarkButtonTapped.withUnretained(self).do(onNext: { this, index in
                let collection = this._iTunesData.value[index]
                if let object = this._iTunesCollectionLocalData.value.first(where: {$0.collectionViewUrl == collection.collectionViewUrl}) {
                    _ = this.localDatabaseITunesCollectionType.removeSavedCollection(object: object)
                } else {
                    _ = this.localDatabaseITunesCollectionType.saveITunesCollection(object: iTunesCollectionObject.convertFromITunesCollection(collection: collection))
                }
                this.getBookmarkedITunesCollectionFromLocal()
            }).subscribe(),
            _onSearchTextChanged.withUnretained(self).do(onNext: { this, searchKey in
                if !searchKey.isEmpty {
                    this.getITunesCollectionResponse(term: searchKey)
                } else {
                    this._iTunesData.accept([])
                }
            }).subscribe()
        ])
        getBookmarkedITunesCollectionFromLocal()
        
    }
    
    private func getITunesCollectionResponse(term: String) {
        iTunesSearchAPIType.forITunesSearch(term: term).map {$0.results}.subscribe(with: self) { this, data in
            this._iTunesData.accept(data)
        }.disposed(by: disposeBag)
    }
    
    private func getBookmarkedITunesCollectionFromLocal() {
        if let array: [iTunesCollectionObject] = localDatabaseITunesCollectionType.getAllSavedITunesCollection()?.compactMap({ $0 }) {
            _iTunesCollectionLocalData.accept(array)
        }
    }
}

extension ViewModelInput where ViewModel: AlbumViewModel {
    var onCollectionTapped: AnyObserver<Int> {
        base._onCollectionTapped.asObserver()
    }
    
    var onReload: AnyObserver<Void> {
        base._onReload.asObserver()
    }
    
    var onBookmarkButtonTapped: AnyObserver<Int> {
        base._onBookmarkButtonTapped.asObserver()
    }
    
    var onSearchTextChanged: AnyObserver<String> {
        base._onSearchTextChanged.asObserver()
    }
}

extension ViewModelOutput where ViewModel: AlbumViewModel {    
    var navigationTitle: Driver<String> {
        base.stringProvider.stringObservable(forKey: "main_view_app_bar_title_albums").asDriver(onErrorJustReturn: "")
    }
    
    var tabbarTitle: Driver<String> {
        base.stringProvider.stringObservable(forKey: "main_view_bottom_navigation_item_title_albums").asDriver(onErrorJustReturn: "")
    }
    
    var searchTextFieldPlaceHolder: Driver<String> {
        base.stringProvider.stringObservable(forKey: "album_view_placeholder_search").asDriver(onErrorJustReturn: "")
    }
    
    var iTunesData: Observable<[iTunesCollection]> {
        Observable.combineLatest(base._iTunesData, base._iTunesCollectionLocalData).map { $0.0 }.asObservable()
    }
    
    func isAlbumBookmarked(_ iTunesCollection: iTunesCollection) -> Bool {
        return base._iTunesCollectionLocalData.value.contains { bookmarkedAlbum in
            bookmarkedAlbum.collectionId == iTunesCollection.collectionId
        }
    }
}
