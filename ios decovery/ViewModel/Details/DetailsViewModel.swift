//
//  DetailsViewModel.swift
//  ios decovery
//
//  Created by Ray Chow on 25/5/2023.
//

import Foundation
import RxSwift

class DetailsViewModel: CommonViewModel {
    var onError: Observable<Error> { _onError }
    fileprivate let stringProvider: StringProvider
    fileprivate let _onError = PublishSubject<Error>()
    fileprivate let _onCloseTapped = PublishSubject<Void>()
    fileprivate let modalViewCorrdinatorType: ModalViewCorrdinatorType
    private let disposeBag = DisposeBag()
    
    init(modalViewCorrdinatorType: ModalViewCorrdinatorType, stringProvider: StringProvider) {
        self.modalViewCorrdinatorType = modalViewCorrdinatorType
        self.stringProvider = stringProvider
        
        _onCloseTapped.withUnretained(self).do { this, _ in
            this.modalViewCorrdinatorType.dismissView()
        }.subscribe().disposed(by: disposeBag)
    }
}

extension ViewModelInput where ViewModel: DetailsViewModel {
    var onCloseTapped: AnyObserver<Void> {
        base._onCloseTapped.asObserver()
    }
}

extension ViewModelOutput where ViewModel: DetailsViewModel {
    
}
