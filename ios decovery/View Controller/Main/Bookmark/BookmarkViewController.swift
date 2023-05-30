//
//  BookmarkViewController.swift
//  ios decovery
//
//  Created by Ray Chow on 23/5/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import TinyConstraints

class BookmarkViewController: UIViewController {
    public typealias ViewModel = BookmarkViewModel
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
        navigationController?.tabBarItem.image = UIImage(named: "bookmark_added")
        
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
            $0.backgroundColor = .white
            $0.edgesToSuperview()
            $0.register(BookmarkTableViewCell.self, forCellReuseIdentifier: BookmarkTableViewCell.reuseId)
        }
    }
    
    func bindViewModel() {
        disposeBag.insert([
            tableView.rx.setDelegate(self),
            rx.viewWillAppear.bind(to: _viewModel.input.onReload),
            _viewModel.output.navigationTitle.drive(rx.title),
            _viewModel.output.bookmarkedCollections.bind(to: tableView.rx.items) { tableView, row, item in
                if let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkTableViewCell.reuseId) as? BookmarkTableViewCell {
                    cell.setupCell(object: item)
                    return cell
                }
                return UITableViewCell()
            },
            tableView.rx.itemDeleted.map({$0.row}).bind(to: _viewModel.input.onTableViewCellSwiped)
        ])
    }
}

extension BookmarkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
