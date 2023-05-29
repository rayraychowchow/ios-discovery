//
//  AlbumViewController.swift
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

class AlbumViewController: UIViewController {
    public typealias ViewModel = AlbumViewModel
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
        navigationController?.tabBarItem.image = UIImage(named: "library_music")
        
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
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 66
        }
        
        tableView.register(AlbumResultTableViewCell.self, forCellReuseIdentifier: AlbumResultTableViewCell.reuseId)
    }
    
    func bindViewModel() {
        disposeBag.insert([
            _viewModel.output.iTunesData.bind(to: tableView.rx.items) { [weak self] tableView, index, item in
                guard let this = self else { return UITableViewCell() }
                if let cell = tableView.dequeueReusableCell(withIdentifier: AlbumResultTableViewCell.reuseId) as? AlbumResultTableViewCell {
                    cell.setupCell(ituneCollection: item)
                    cell.bookmarkButton.rx.tap.map({ _ in index }).bind(to: this._viewModel.input.onBookmarkButtonTapped).disposed(by: cell.disposeBag)
                    return cell
                }
                    
                return UITableViewCell()
            },
            rx.viewWillAppear.take(1).bind(to: _viewModel.input.onReload),
            _viewModel.output.navigationTitle.drive(rx.title)
        ])
    }
}
