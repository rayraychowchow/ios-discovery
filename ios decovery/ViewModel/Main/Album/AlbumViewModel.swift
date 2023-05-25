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
    fileprivate let networkService: NetworkService
    fileprivate let localDatabaseService: LocalDatabaseService
    fileprivate let albumCoordinatorType: AlbumCoordinatorType
    
    fileprivate let onTestButtonTapped = PublishSubject<Void>()
    
    
    init(albumCoordinatorType: AlbumCoordinatorType, stringProvider: StringProvider, networkService: NetworkService, localDatabaseService: LocalDatabaseService) {
        self.albumCoordinatorType = albumCoordinatorType
        self.stringProvider = stringProvider
        self.networkService = networkService
        self.localDatabaseService = localDatabaseService
        
        onTestButtonTapped.withUnretained(self).do { this, _ in
            this.albumCoordinatorType.presentAlbumDetailsView()
        }.subscribe().disposed(by: disposeBag)
    }
}

extension ViewModelInput where ViewModel: AlbumViewModel {
    var onTestButtonTapped: AnyObserver<Void> {
        base.onTestButtonTapped.asObserver()
    }
}

extension ViewModelOutput where ViewModel: AlbumViewModel {    
    var tabbarTitle: Driver<String> {
        base.stringProvider.stringObservable(forKey: "main_view_bottom_navigation_item_title_albums").asDriver(onErrorJustReturn: "")
    }
}
