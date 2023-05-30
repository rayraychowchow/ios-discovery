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

class AlbumViewController: UIViewController, UISearchBarDelegate {
    public typealias ViewModel = AlbumViewModel
    private let _viewModel: ViewModel
    private let disposeBag = DisposeBag()
    
    private let searchBar = UISearchBar()
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
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        searchBar.do {
            $0.returnKeyType = .done
            $0.height(48)
            $0.edgesToSuperview(excluding: .bottom, usingSafeArea: true)
        }

        tableView.do {
            $0.backgroundColor = .white
            $0.topToBottom(of: searchBar)
            $0.edgesToSuperview(excluding: .top)
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 66
        }
        
        tableView.register(AlbumResultTableViewCell.self, forCellReuseIdentifier: AlbumResultTableViewCell.reuseId)
    }
    
    func bindViewModel() {
        disposeBag.insert([
            _viewModel.output.searchTextFieldPlaceHolder.drive(searchBar.rx.placeholder),
            _viewModel.output.iTunesData.bind(to: tableView.rx.items) { [weak self] tableView, index, item in
                guard let this = self else { return UITableViewCell() }
                if let cell = tableView.dequeueReusableCell(withIdentifier: AlbumResultTableViewCell.reuseId) as? AlbumResultTableViewCell {
                    cell.setupCell(ituneCollection: item, isBookmarked: this._viewModel.output.isAlbumBookmarked(item))
                    cell.bookmarkButton.rx.tap.map({ _ in index }).bind(to: this._viewModel.input.onBookmarkButtonTapped).disposed(by: cell.disposeBag)
                    return cell
                }
                    
                return UITableViewCell()
            },
            rx.viewWillAppear.bind(to: _viewModel.input.onReload),
            _viewModel.output.navigationTitle.drive(rx.title),
            searchBar.rx.text.orEmpty.debounce(RxTimeInterval.microseconds(300), scheduler: MainScheduler.instance).distinctUntilChanged().bind(to: _viewModel.input.onSearchTextChanged),
            searchBar.searchTextField.rx.controlEvent(.editingDidEndOnExit).withUnretained(self).do(onNext: { this, _ in
                this.searchBar.resignFirstResponder()
            }).subscribe()
        ])
    }
}

//searchBar.rx.text.debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).distinctUntilChanged().bind(to: _viewModel.input.onSearchTextChanged)
