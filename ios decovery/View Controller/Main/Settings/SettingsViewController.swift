//
//  SettingsViewController.swift
//  ios decovery
//
//  Created by Ray Chow on 23/5/2023.
//

import Foundation
import UIKit
import RxSwift
import Then
import TinyConstraints

class SettingsViewController: UIViewController {
    public typealias ViewModel = SettingsViewModel
    private let _viewModel: ViewModel
    private let disposeBag = DisposeBag()
    
    private let tableView = UITableView()
    
    private let button = UIButton()
    
    init(viewModel: ViewModel) {
        _viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTabBar() {
        navigationController?.tabBarItem.image = UIImage(named: "settings")
        
        if let tabBarItemRxTitle = navigationController?.tabBarItem.rx.title {
            _viewModel.output.tabbarTitle.drive(tabBarItemRxTitle).disposed(by: disposeBag)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(button)
        button.do {
            $0.setTitle("ascoinasco", for: .normal)
            $0.centerInSuperview()
            $0.setTitleColor(.black, for: .normal)
        }
    }
    
    func bindViewModel() {
        button.rx.tap.bind(to: _viewModel.input.onLanguageButtonTapped).disposed(by: disposeBag)
        
    }
}
