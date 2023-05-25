//
//  SettingsViewModel.swift
//  ios decovery
//
//  Created by Ray Chow on 23/5/2023.
//

import Foundation
import RxSwift
import RxCocoa

class SettingsViewModel: CommonViewModel {
    fileprivate let _onError = PublishSubject<Error>()
    var onError: Observable<Error> { _onError }
    
    fileprivate let stringProvider: StringProvider
    fileprivate let userDefaultsStore: UserDefaultsStore
    fileprivate let _onLanguageButtonTapped = PublishSubject<Void>()
    fileprivate let languageCoordinatorType: LanguageCoordinatorType
    fileprivate let disposeBag = DisposeBag()
    
    init(languageCoordinatorType: LanguageCoordinatorType, stringProvider: StringProvider, userDefaultsStore: UserDefaultsStore) {
        self.stringProvider = stringProvider
        self.userDefaultsStore = userDefaultsStore
        self.languageCoordinatorType = languageCoordinatorType
        
        _onLanguageButtonTapped.withUnretained(self).do { this, _ in
            this.languageCoordinatorType.changeLanguage()
        }.subscribe().disposed(by: disposeBag)
    }
}

extension ViewModelInput where ViewModel: SettingsViewModel {
    var onLanguageButtonTapped: AnyObserver<Void> {
        base._onLanguageButtonTapped.asObserver()
    }
}

extension ViewModelOutput where ViewModel: SettingsViewModel {
    var tabbarTitle: Driver<String> {
        base.stringProvider.stringObservable(forKey: "main_view_bottom_navigation_item_title_settings").asDriver(onErrorJustReturn: "")
    }
}

