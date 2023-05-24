//
//  ViewModelType.swift
//  MoyaStudy
//
//  Created by Ray Chow on 18/2/2022.
//

import Foundation

public protocol ViewModelType {}

public struct ViewModelInput<ViewModel: ViewModelType> {
    /// Base object to extend.
    public let base: ViewModel

    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    init(_ base: ViewModel) {
        self.base = base
    }
}

public struct ViewModelOutput<ViewModel: ViewModelType> {
    /// Base object to extend.
    public let base: ViewModel

    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    init(_ base: ViewModel) {
        self.base = base
    }
}

extension ViewModelType {
    public var input: ViewModelInput<Self> {
        get {
            return ViewModelInput(self)
        }
    }
    
    public var output: ViewModelOutput<Self> {
        get {
            return ViewModelOutput(self)
        }
    }
}
