//
//  Coordinator.swift
//  ios decovery
//
//  Created by Ray Chow on 23/5/2023.
//

import Foundation
import UIKit
import RxSwift

class Coordinator: AlbumCoordinatorType, LanguageCoordinatorType {
    
    
    let networkService = NetworkService()
    let userDefaultsStore = UserDefaultsStore()
    let localDatabaseService = LocalDatabaseService()
    let onChangeLanguageStream = PublishSubject<Language>()
    let stringProvider:StringProvider
    
    init() {
        stringProvider = StringProvider(onChangeLanguage: onChangeLanguageStream)
        let currentLanguage = UserDefaultsStore.shared.currentLanguage ?? Language.en
        onChangeLanguageStream.onNext(currentLanguage)
    }
    
    private var _rootViewController = UIViewController()
    
    var rootViewController: UIViewController {
        return _rootViewController
    }
    
    func onAppStart() {
        let sceneCreator = SceneCreator(coordinator: self)
        _rootViewController = sceneCreator.forMainTabController() ?? UIViewController()
    }
    
    func presentAlbumDetailsView() {
        
    }
    
    func changeLanguage() {
        let currentLanguage = UserDefaultsStore.shared.currentLanguage ?? Language.en
        if (currentLanguage == .en) {
            onChangeLanguageStream.onNext(.zh_hk)
        } else {
            onChangeLanguageStream.onNext(.en)
        }
        
    }
}
