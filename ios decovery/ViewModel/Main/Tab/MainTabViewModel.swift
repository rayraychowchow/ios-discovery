//
//  MainTabViewModel.swift
//  ios decovery
//
//  Created by Ray Chow on 23/5/2023.
//

import Foundation
import RxSwift
import RxCocoa

class MainTabViewModel: CommonViewModel {
    var onError: Observable<Error> { _onError }
    let stringProvider: StringProvider
    fileprivate let _onError = PublishSubject<Error>()
    fileprivate let _onTabSwitched = BehaviorSubject(value: 0)
    
    init(stringProvider: StringProvider) {
        self.stringProvider = stringProvider
    }
}

extension ViewModelInput where ViewModel: MainTabViewModel {
    var onTabSwitched: AnyObserver<Int> {
        base._onTabSwitched.asObserver()
    }
}

extension ViewModelOutput where ViewModel: MainTabViewModel {
    var navigationTitle: Driver<String> {
        base._onTabSwitched.flatMapLatest({ tabIndex -> Observable<String> in
            let mainTabScene = MainTabScene.allCases[tabIndex]
            switch (mainTabScene) {
            case .album:
                return base.stringProvider.stringObservable(forKey: "main_view_bottom_navigation_item_title_albums")
            case .bookmark:
                return base.stringProvider.stringObservable(forKey: "main_view_bottom_navigation_item_title_bookmark")
            case .settings:
                return base.stringProvider.stringObservable(forKey: "main_view_bottom_navigation_item_title_settings")
            }
        }).asDriver(onErrorJustReturn: "")
    }
}
