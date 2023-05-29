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
    fileprivate let localDatabaseService: LocalDatabaseService
    fileprivate let albumCoordinatorType: AlbumCoordinatorType
    
    fileprivate let onTestButtonTapped = PublishSubject<Void>()
    fileprivate let onReload = PublishSubject<Void>()
    
    fileprivate let iTunesData = BehaviorRelay<[iTunesCollection]>(value: [])
    
    
    init(albumCoordinatorType: AlbumCoordinatorType, stringProvider: StringProvider, iTunesSearchAPIType: ITunesSearchAPIType, localDatabaseService: LocalDatabaseService) {
        self.albumCoordinatorType = albumCoordinatorType
        self.stringProvider = stringProvider
        self.iTunesSearchAPIType = iTunesSearchAPIType
        self.localDatabaseService = localDatabaseService
        
        disposeBag.insert([
            onTestButtonTapped.withUnretained(self).do { this, _ in
                this.albumCoordinatorType.presentAlbumDetailsView()
            }.subscribe(),
            onReload.withUnretained(self).do(onNext: { this, _ in
                this.getITunesCollectionResponse()
            }).subscribe()
        ])
    }
    
    private func getITunesCollectionResponse() {
        iTunesSearchAPIType.forITunesSearch(term: "Jack").map {$0.results}.subscribe(with: self) { this, data in
            this.iTunesData.accept(data)
        }.disposed(by: disposeBag)
    }
}

extension ViewModelInput where ViewModel: AlbumViewModel {
    var onTestButtonTapped: AnyObserver<Void> {
        base.onTestButtonTapped.asObserver()
    }
    
    var onReload: AnyObserver<Void> {
        base.onReload.asObserver()
    }
}

extension ViewModelOutput where ViewModel: AlbumViewModel {    
    var navigationTitle: Driver<String> {
        base.stringProvider.stringObservable(forKey: "main_view_app_bar_title_albums").asDriver(onErrorJustReturn: "")
    }
    
    var tabbarTitle: Driver<String> {
        base.stringProvider.stringObservable(forKey: "main_view_bottom_navigation_item_title_albums").asDriver(onErrorJustReturn: "")
    }
}
