//
//  DetailsViewModel.swift
//  ios decovery
//
//  Created by Ray Chow on 25/5/2023.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class DetailsViewModel: CommonViewModel {
    var onError: Observable<Error> { _onError }
    fileprivate let stringProvider: StringProvider
    fileprivate let imageProvider: ImageProvider
    fileprivate let localDatabaseITunesCollectionType: LocalDatabaseITunesCollectionType
    fileprivate let _onError = PublishSubject<Error>()
    fileprivate let _onCloseTapped = PublishSubject<Void>()
    fileprivate let modalViewCorrdinatorType: ModalViewCorrdinatorType
    fileprivate let _onBookmarkButtonTapped = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    fileprivate let collection: iTunesCollection
    fileprivate let _isBookmarked = BehaviorRelay(value: false)
    fileprivate let localCollection = BehaviorRelay<[iTunesCollectionObject]>(value: [])
    
    init(modalViewCorrdinatorType: ModalViewCorrdinatorType, stringProvider: StringProvider, imageProvider: ImageProvider, localDatabaseITunesCollectionType: LocalDatabaseITunesCollectionType, collection: iTunesCollection, isBookmarked: Bool) {
        self.modalViewCorrdinatorType = modalViewCorrdinatorType
        self.stringProvider = stringProvider
        self.imageProvider = imageProvider
        self.localDatabaseITunesCollectionType = localDatabaseITunesCollectionType
        self.collection = collection
        _isBookmarked.accept(isBookmarked)
        
        _onCloseTapped.withUnretained(self).do { this, _ in
            this.modalViewCorrdinatorType.dismissView()
        }.subscribe().disposed(by: disposeBag)
        
        _onBookmarkButtonTapped.withUnretained(self).do { this, _ in
            if let object = this.localCollection.value.first(where: { $0.collectionViewUrl == this.collection.collectionViewUrl }) {
                _ = localDatabaseITunesCollectionType.removeSavedCollection(object: object)
            } else {
                _ = localDatabaseITunesCollectionType.saveITunesCollection(object: iTunesCollectionObject.convertFromITunesCollection(collection: collection))
            }
            this._isBookmarked.accept(!this._isBookmarked.value)
            this.getBookmarkedITunesCollectionFromLocal()
        }.subscribe().disposed(by: disposeBag)
        
        getBookmarkedITunesCollectionFromLocal()
    }
    
    private func getBookmarkedITunesCollectionFromLocal() {
        if let array: [iTunesCollectionObject] = localDatabaseITunesCollectionType.getAllSavedITunesCollection()?.compactMap({ $0 }) {
            localCollection.accept(array)
        }
    }
}

extension ViewModelInput where ViewModel: DetailsViewModel {
    var onCloseTapped: AnyObserver<Void> {
        base._onCloseTapped.asObserver()
    }
    
    var onBookmarkButtonTapped: AnyObserver<Void> {
        base._onBookmarkButtonTapped.asObserver()
    }
}

extension ViewModelOutput where ViewModel: DetailsViewModel {
    var isBookmarked: Observable<Bool> {
        base._isBookmarked.asObservable()
    }
    
    var collectionTitle: Driver<String> {
        Observable.of(base.collection).map({
            $0.collectionName ?? ""
            
        }).asDriver(onErrorDriveWith: .never())
    }
    
    var collectionArtistName: Driver<String> {
        Observable.of(base.collection).map({ $0.artistName ?? "" }).asDriver(onErrorDriveWith: .never())
    }
    
    var collectionImage: Driver<UIImage> {
        Observable.of(base.collection).flatMapLatest { collection in
            base.imageProvider._getImage(forPath: collection.artworkUrl100)
        }.asDriver(onErrorDriveWith: .never())
    }
    
    var closeButtonTitle: Driver<String> {
        base.stringProvider.stringObservable(forKey: "general_close").asDriver(onErrorDriveWith: .never())
    }
}
