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
    fileprivate let onReload = PublishSubject<Void>()
    
    fileprivate let settings = BehaviorRelay<[AppSettings]>(value: [])
    
    init(languageCoordinatorType: LanguageCoordinatorType, stringProvider: StringProvider, userDefaultsStore: UserDefaultsStore) {
        self.stringProvider = stringProvider
        self.userDefaultsStore = userDefaultsStore
        self.languageCoordinatorType = languageCoordinatorType
        
        disposeBag.insert([
            _onLanguageButtonTapped.withUnretained(self).do { this, _ in
                this.languageCoordinatorType.changeLanguage()
            }.subscribe(),
            onReload.withUnretained(self).do(onNext: { this, _ in
                this.getSettings()
            }).subscribe()
        ])
    }
    
    private func getSettings() {
        settings.accept([AppSettings.language(model: LanguageSetting(currentLanguage: Language.en, title: "ENG")), AppSettings.darkMode(model: DarkModeSetting(isDarkMode: true, title: "dark mode"))])
    }
}
//rx.viewWillAppear.take(1).mapAsVoid().bind(to: _viewModel.input.onReload),
extension ViewModelInput where ViewModel: SettingsViewModel {
    var onReload: AnyObserver<Void> {
        base.onReload.asObserver()
    }
    
    var onLanguageButtonTapped: AnyObserver<Void> {
        base._onLanguageButtonTapped.asObserver()
    }
}

extension ViewModelOutput where ViewModel: SettingsViewModel {
    var tabbarTitle: Driver<String> {
        base.stringProvider.stringObservable(forKey: "main_view_bottom_navigation_item_title_settings").asDriver(onErrorJustReturn: "")
    }
    
    var data: Observable<[AppSettings]> {
        base.settings.asObservable()
    }
}

