//
//  MainTabViewModel.swift
//  ios decovery
//
//  Created by Ray Chow on 23/5/2023.
//

import Foundation
import RxSwift

class MainTabViewModel: CommonViewModel {
    fileprivate let _onError = PublishSubject<Error>()
    var onError: Observable<Error> { _onError }
    init() {}
}

extension ViewModelInput where ViewModel: MainTabViewModel {
    
}

extension ViewModelOutput where ViewModel: MainTabViewModel {
   
}
