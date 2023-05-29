//
//  SettingsViewController.swift
//  ios decovery
//
//  Created by Ray Chow on 23/5/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Then
import TinyConstraints

class SettingsViewController: UIViewController {
    public typealias ViewModel = SettingsViewModel
    private let _viewModel: ViewModel
    private let disposeBag = DisposeBag()
    
    private let tableView = UITableView()
    
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
        
        view.addSubview(tableView)
        tableView.do {
            $0.edgesToSuperview()
            $0.backgroundColor = .white
            $0.rowHeight = 44
        }
        
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.reuseId)
        tableView.register(SettingsWithSwitchTableViewCell.self, forCellReuseIdentifier: SettingsWithSwitchTableViewCell.reuseId)
    }
    
    func bindViewModel() {
        _viewModel.output.data.bind(to: tableView.rx.items) { [weak self] tableview, index, appSetting in
            guard let this = self else { return UITableViewCell() }
            switch (appSetting) {
            case .language(let model):
                if let cell = tableview.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseId) as? SettingsTableViewCell {
                    cell.setupCell(languageSetting: model)
                    return cell
                }
                break
            case .darkMode(let model):
                if let cell = tableview.dequeueReusableCell(withIdentifier: SettingsWithSwitchTableViewCell.reuseId) as? SettingsWithSwitchTableViewCell {
                    cell.setupCell(darkModeSetting: model)
                    cell.switchButton.rx.isOn.bind(to: this._viewModel.input.onDarkModeSwitched).disposed(by: cell.disposeBag)
                    return cell
                }
                break
            }
            return UITableViewCell()
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.withUnretained(self).do { this, indexPath in
            this.tableView.deselectRow(at: indexPath, animated: true)
            if indexPath.row == 0 {
                this._viewModel.input.onLanguageButtonTapped.onNext(())
            }
        }.subscribe().disposed(by: disposeBag)
  
        rx.viewWillAppear.take(1).bind(to: _viewModel.input.onReload).disposed(by: disposeBag)
    }
}
