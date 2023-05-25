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

class BookmarkViewController: UIViewController {
    public typealias ViewModel = BookmarkViewModel
    private let _viewModel: ViewModel
    private let disposeBag = DisposeBag()
    
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
        view.backgroundColor = .green
              
    }
}
