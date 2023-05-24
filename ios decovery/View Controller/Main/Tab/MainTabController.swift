//
//  MainTabController.swift
//  ios decovery
//
//  Created by Ray Chow on 23/5/2023.
//

import Foundation
import UIKit

class MainTabController : UITabBarController {
    public typealias ViewModel = MainTabViewModel
    private let _viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        _viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self

        tabBar.backgroundColor = UIColor.white
    }
    
    
}

extension MainTabController: UITabBarControllerDelegate {
    
}
