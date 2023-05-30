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
    
    fileprivate let onTestButtonTapped = PublishSubject<Void>()
    fileprivate let onReload = PublishSubject<Void>()
    fileprivate let onBookmarkButtonTapped = PublishSubject<Int>()
    
    fileprivate let iTunesData = BehaviorRelay<[iTunesCollection]>(value: [])
    fileprivate let iTunesCollectionLocalData = BehaviorRelay<[iTunesCollectionObject]>(value: [])
    
    init(albumCoordinatorType: AlbumCoordinatorType, stringProvider: StringProvider, iTunesSearchAPIType: ITunesSearchAPIType, localDatabaseITunesCollectionType: LocalDatabaseITunesCollectionType) {
        self.albumCoordinatorType = albumCoordinatorType
        self.stringProvider = stringProvider
        self.iTunesSearchAPIType = iTunesSearchAPIType
        self.localDatabaseITunesCollectionType = localDatabaseITunesCollectionType
        
        disposeBag.insert([
            onTestButtonTapped.withUnretained(self).do { this, _ in
                this.albumCoordinatorType.presentAlbumDetailsView()
            }.subscribe(),
            onReload.withUnretained(self).do(onNext: { this, _ in
                this.getITunesCollectionResponse()
            }).subscribe(),
            onBookmarkButtonTapped.withUnretained(self).do(onNext: { this, index in
                let album = this.iTunesData.value[index]
                if let object = this.iTunesCollectionLocalData.value.first(where: {$0.collectionViewUrl == album.collectionViewUrl}) {
                    _ = this.localDatabaseITunesCollectionType.removeSavedCollection(object: object)
                } else {
                    _ = this.localDatabaseITunesCollectionType.saveITunesCollection(object: iTunesCollectionObject.convertFromITunesCollection(collection: album))
                }
                this.getBookmarkedITunesCollectionFromLocal()
            }).subscribe()
        ])
        getBookmarkedITunesCollectionFromLocal()
        
    }
    
    private func getITunesCollectionResponse() {
        iTunesSearchAPIType.forITunesSearch(term: "Jack").map {$0.results}.subscribe(with: self) { this, data in
            this.iTunesData.accept(data)
        }.disposed(by: disposeBag)
    }
    
    private func getBookmarkedITunesCollectionFromLocal() {
        if let array: [iTunesCollectionObject] = localDatabaseITunesCollectionType.getAllSavedITunesCollection()?.compactMap({ $0 }) {
            iTunesCollectionLocalData.accept(array)
        }
    }
}

extension ViewModelInput where ViewModel: AlbumViewModel {
    var onTestButtonTapped: AnyObserver<Void> {
        base.onTestButtonTapped.asObserver()
    }
    
    var onReload: AnyObserver<Void> {
        base.onReload.asObserver()
    }
    
    var onBookmarkButtonTapped: AnyObserver<Int> {
        base.onBookmarkButtonTapped.asObserver()
    }
}

extension ViewModelOutput where ViewModel: AlbumViewModel {    
    var navigationTitle: Driver<String> {
        base.stringProvider.stringObservable(forKey: "main_view_app_bar_title_albums").asDriver(onErrorJustReturn: "")
    }
    
    var tabbarTitle: Driver<String> {
        base.stringProvider.stringObservable(forKey: "main_view_bottom_navigation_item_title_albums").asDriver(onErrorJustReturn: "")
    }
    
    var iTunesData: Observable<[iTunesCollection]> {
        Observable.combineLatest(base.iTunesData, base.iTunesCollectionLocalData).map { $0.0 }.asObservable()
    }
    
    func isAlbumBookmarked(_ iTunesCollection: iTunesCollection) -> Bool {
        return base.iTunesCollectionLocalData.value.contains { bookmarkedAlbum in
            bookmarkedAlbum.collectionId == iTunesCollection.collectionId
        }
    }
}
