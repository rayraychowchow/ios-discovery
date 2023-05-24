//
//  SettingsViewModel.swift
//  ios decovery
//
//  Created by Ray Chow on 23/5/2023.
//

import Foundation
import RxSwift

class SettingsViewModel: CommonViewModel {
    fileprivate let _onError = PublishSubject<Error>()
    var onError: Observable<Error> { _onError }
    
    private let userDefaultsStore: UserDefaultsStore
    
    init(userDefaultsStore: UserDefaultsStore) {
        self.userDefaultsStore = userDefaultsStore
    }
}

extension ViewModelInput where ViewModel: SettingsViewModel {
    
}

extension ViewModelOutput where ViewModel: SettingsViewModel {
   
}

