//
//  SceneCreator.swift
//  ios decovery
//
//  Created by Ray Chow on 23/5/2023.
//

import Foundation
import UIKit
import RxSwift

class SceneCreator {
    typealias ResultType = UIViewController?
    
    let parent: Coordinator
    
    var networkService: NetworkService { parent.networkService }
    var userDefaultsStore: UserDefaultsStore { parent.userDefaultsStore }
    var localDatabaseService: LocalDatabaseService { parent.localDatabaseService }
    var stringProvider: StringProvider { parent.stringProvider }
    var onChangeLanguageStream: PublishSubject<Language> { parent.onChangeLanguageStream }
    
    init(coordinator: Coordinator) {
        parent = coordinator
    }
    
    func forMainTabController() -> ResultType {
        var viewControllers: [UIViewController] = []
        MainTabScene.allCases.forEach { scene in
            if let vc = getViewControllerForMainTab(scene) {
                viewControllers.append(vc)
            }
        }
        let mainTabController = MainTabController(viewModel: MainTabViewModel(stringProvider: stringProvider), viewControllers: viewControllers)
        return mainTabController
    }
    
    private func embedWithUINavigationController(viewController: UIViewController) -> ResultType {
        let navigationController = CustomNavigationController(rootViewController: viewController)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).standardAppearance = appearance
        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).scrollEdgeAppearance = appearance
        
        navigationController.modalPresentationStyle = .fullScreen
        return navigationController
    }
    
    private func getViewControllerForMainTab(_ scene: MainTabScene) -> ResultType {
        switch (scene) {
        case .album:
            let viewModel = AlbumViewModel(albumCoordinatorType: parent, stringProvider: stringProvider, networkService: networkService, localDatabaseService: localDatabaseService)
            let albumVC = AlbumViewController(viewModel: viewModel)
            let albumWithNavVC = embedWithUINavigationController(viewController: albumVC)
            albumVC.setupTabBar()
            return albumWithNavVC
        case .bookmark:
            let viewModel = BookmarkViewModel(stringProvider: stringProvider, localDatabaseService: localDatabaseService)
            let bookmarkVC = BookmarkViewController(viewModel: viewModel)
            let bookmarkWithNavVC = embedWithUINavigationController(viewController: bookmarkVC)
            bookmarkVC.setupTabBar()
            return bookmarkWithNavVC
        case .settings:
            let viewModel = SettingsViewModel(languageCoordinatorType: parent, stringProvider: stringProvider, userDefaultsStore: userDefaultsStore)
            let settingsVC = SettingsViewController(viewModel: viewModel)
            let settingsWithNavVC = embedWithUINavigationController(viewController: settingsVC)
            settingsVC.setupTabBar()
            return settingsWithNavVC
        }
    }
    
    func getDetailsViewController() -> ResultType {
        return embedWithUINavigationController(viewController: DetailsViewController(viewModel: DetailsViewModel(modalViewCorrdinatorType: parent, stringProvider: stringProvider)))
    }
}
