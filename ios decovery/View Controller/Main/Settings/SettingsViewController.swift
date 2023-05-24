//
//  SettingsViewController.swift
//  ios decovery
//
//  Created by Ray Chow on 23/5/2023.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    public typealias ViewModel = SettingsViewModel
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
        view.backgroundColor = .yellow
        tabBarItem.image = UIImage.checkmark
        tabBarItem.title = "Settings"
    }
}
