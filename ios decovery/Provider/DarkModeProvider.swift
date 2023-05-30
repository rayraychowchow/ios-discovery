//
//  DarkModeProvider.swift
//  ios decovery
//
//  Created by Ray Chow on 30/5/2023.
//

import Foundation
import RxSwift
import RxCocoa

class DarkModeProvider {
    let darkModeStream = BehaviorRelay(value: false)
    let disposeBag = DisposeBag()
}
