//
//  Coordinator.swift
//  ios decovery
//
//  Created by Ray Chow on 23/5/2023.
//

import Foundation
import UIKit
import RxSwift

class Coordinator: AlbumCoordinatorType, LanguageCoordinatorType, ModalViewCorrdinatorType, DarkModeCoordinatorType {
    var window: UIWindow?
    
    let networkService = NetworkService()
    let userDefaultsStore = UserDefaultsStore()
    let localDatabaseService = LocalDatabaseService()
    let onChangeLanguageStream = PublishSubject<Language>()
    let stringProvider: StringProvider
    let imageProvider: ImageProvider
    let darkModeProvider: DarkModeProvider
    
    init() {
        stringProvider = StringProvider(onChangeLanguage: onChangeLanguageStream)
        imageProvider = ImageProvider()
        darkModeProvider = DarkModeProvider()
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
    
    func dismissView() {
        _rootViewController.dismiss(animated: true)
    }
    
    func presentAlbumDetailsView(collection: iTunesCollection, isBookMarked: Bool) {
        let sceneCreator = SceneCreator(coordinator: self)
        guard let detailsVC = sceneCreator.getDetailsViewController(collection: collection, isBookMarked: isBookMarked) else { return }
        _rootViewController.present(detailsVC, animated: true)
    }
    
    func changeLanguage() {
        let currentLanguage = UserDefaultsStore.shared.currentLanguage ?? Language.en
        if (currentLanguage == .en) {
            onChangeLanguageStream.onNext(.zh_hk)
        } else {
            onChangeLanguageStream.onNext(.en)
        }
    }
    
    func changeToDarkMode(_ toDarkMode: Bool) {
        window?.overrideUserInterfaceStyle = toDarkMode ? .dark : .light
        UserDefaultsStore.shared.isDarkMode = toDarkMode
        darkModeProvider.darkModeStream.accept(toDarkMode)
    }
}
