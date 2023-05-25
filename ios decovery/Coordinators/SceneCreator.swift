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
        let mainTabController = MainTabController(viewModel: MainTabViewModel(stringProvider: stringProvider))
        var viewControllers: [UIViewController] = []
        MainTabScene.allCases.forEach { scene in
            if let vc = getViewControllerForMainTab(scene) {
                viewControllers.append(vc)
            }
        }
        mainTabController.viewControllers = viewControllers
        mainTabController.selectedIndex = 0
        
        return embedWithUINavigationController(viewController: mainTabController)
    }
    
    private func embedWithUINavigationController(viewController: UIViewController) -> ResultType {
        let navigationController = UINavigationController(rootViewController: viewController)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).standardAppearance = appearance
        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).scrollEdgeAppearance = appearance
        
        
        return navigationController
    }
    
    private func getViewControllerForMainTab(_ scene: MainTabScene) -> ResultType {
        switch (scene) {
        case .album:
            let viewModel = AlbumViewModel(stringProvider: stringProvider, networkService: networkService, localDatabaseService: localDatabaseService)
            return AlbumViewController(viewModel: viewModel)
        case .bookmark:
            let viewModel = BookmarkViewModel(localDatabaseService: localDatabaseService)
            return BookmarkViewController(viewModel: viewModel)
        case .settings:
            let viewModel = SettingsViewModel(userDefaultsStore: userDefaultsStore)
            return SettingsViewController(viewModel: viewModel)
        }
    }
}
