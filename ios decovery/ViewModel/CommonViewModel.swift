//
//  CommonViewModel.swift
//  MoyaStudy
//
//  Created by Ray Chow on 18/2/2022.
//

import Foundation
import RxSwift

public protocol CommonViewModel: ViewModelType {
    var onError: Observable<Error> { get }
}
