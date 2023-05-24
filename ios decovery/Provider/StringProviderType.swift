//
//  StringProviderType.swift
//  ios decovery
//
//  Created by Ray Chow on 23/5/2023.
//


import Foundation
import RxSwift

public protocol StringProviderType {
    var onChangeLanguage: Observable<Language> { get }
    
    func getString(forKey key: String) -> String
    func getStringWithFormat(forKey key: String, _ arguments: CVarArg...) -> String
    func getStringWithFormat(forKey key: String, arguments: [CVarArg]) -> String
    func stringObservable(forKey key: String) -> Observable<String>
    func stringWithFormatObservable(forKey key: String, _ arguments: CVarArg...) -> Observable<String>
    func stringWithFormatObservable(forKey key: String, arguments: [CVarArg]) -> Observable<String>
}

public protocol WithStringProvider {
    var stringProvider: StringProviderType { get }
}
