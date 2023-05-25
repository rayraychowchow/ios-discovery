//
//  MainTabController.swift
//  ios decovery
//
//  Created by Ray Chow on 23/5/2023.
//

import Foundation
import UIKit
import RxSwift

class MainTabController : UITabBarController {
    public typealias ViewModel = MainTabViewModel
    private let _viewModel: ViewModel
    private let _disposeBag = DisposeBag()
    
    init(viewModel: ViewModel) {
        _viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    func setupUI() {
        tabBar.backgroundColor = UIColor.white
    }
    
    func bindViewModel() {
        _disposeBag.insert (
            [rx.didSelect.withUnretained(self).map { this, vc in
                this.viewControllers?.firstIndex(of: vc) ?? 0
            }.bind(to: _viewModel.input.onTabSwitched),
             _viewModel.output.navigationTitle.drive(navigationItem.rx.title)]
        )
    }
    
}
