//
//  StringProvider.swift
//  ios decovery
//
//  Created by Ray Chow on 23/5/2023.
//

import Foundation
import RxSwift
import RxCocoa

class StringProvider {
    
    private static let queueName = "OneApp.StringProvider"
    private static let rxQueueName = "Rx." + queueName
    private lazy var queue = DispatchQueue(label: Self.queueName, qos: .default)
    //    private static let rootDirectoryName = "AppPatch"
    //    private let rootDirectoryUrl: URL
    
    private let disposeBag = DisposeBag()
    private let translations = BehaviorSubject<[String: String]>(value: [:])
    private let onChangeLanguage:Observable<Language>
    
    init(onChangeLanguage: Observable<Language>) {
        //        let fileManager = FileManager.default
        //        rootDirectoryUrl = (try? fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(Self.rootDirectoryName)) ?? URL(fileURLWithPath: "")
        
        
        
        // get the json and apply to translation
        
        self.onChangeLanguage = onChangeLanguage
        self.onChangeLanguage
            .observe(on: SerialDispatchQueueScheduler(queue: queue, internalSerialQueueName: Self.rxQueueName))
            .withUnretained(self)
            .flatMapLatest({ this, language -> Single<[String:String]> in
                return this.getLanguage(language: language)
            }).bind(to: translations).disposed(by: disposeBag)
    }
    
    private func getLanguage(language: Language) -> Single<[String: String]> {
        let url = getTranslationFileUrl(for: language)
        return Single<[String: String]>.create(subscribe: { observer in
            if let fileUrl = url {
                let translations = (try? Data(contentsOf: fileUrl))
                    .flatMap({
                        (try? JSONSerialization.jsonObject(with: $0, options: [])) as? [String: String]
                    })
                observer(.success(translations ?? [:]))
            } else { observer(.success([:]))
            }
            
            return Disposables.create()
        })
        
    }
    
    private func getTranslationFileUrl(for language: Language) -> URL? {
        let filenamePrefix = "translation-"
        let resourceName: String
        switch language {
        case .en:
            resourceName = filenamePrefix + "en"
            //            rootDirectoryUrl.appendingPathComponent(filenamePrefix + "en")
        case .zh_hk:
            resourceName = filenamePrefix + "zh_hk"
        }
        return Bundle.main.url(forResource: resourceName, withExtension: "json")
    }
    
    private static func getStringFromDictWithFormat(forKey key: String, dict: [String: String], arguments: [CVarArg]) -> String {
        return dict[key].map({
            if arguments.isEmpty {
                return $0
            } else {
                return String(format: $0, arguments: arguments)
            }
        }) ?? key
    }
    
    //
    
    func getStringWithFormat(forKey key: String, arguments: [CVarArg]) -> String {
        let valDict = (try? translations.value()) ?? [:]
        return Self.getStringFromDictWithFormat(forKey: key, dict: valDict, arguments: arguments)
    }
    
    func getStringWithFormat(forKey key: String, _ arguments: CVarArg...) -> String {
        getStringWithFormat(forKey: key, arguments: arguments)
    }
    
    func getString(forKey key: String) -> String {
        getStringWithFormat(forKey: key, arguments: [])
    }
    
    func stringObservable(forKey key: String) -> Observable<String> {
        stringWithFormatObservable(forKey: key, arguments: [])
    }
    
    func stringWithFormatObservable(forKey key: String, _ arguments: CVarArg...) -> Observable<String> {
        stringWithFormatObservable(forKey: key, arguments: arguments)
    }
    
    func stringWithFormatObservable(forKey key: String, arguments: [CVarArg]) -> Observable<String> {
        translations
            .observe(on: SerialDispatchQueueScheduler(queue: queue, internalSerialQueueName: Self.rxQueueName))
            .map({ dict in
                Self.getStringFromDictWithFormat(forKey: key, dict: dict, arguments: arguments)
            })
    }
    
}
