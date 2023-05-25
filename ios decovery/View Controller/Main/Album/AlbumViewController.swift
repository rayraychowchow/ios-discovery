//
//  AlbumViewController.swift
//  ios decovery
//
//  Created by Ray Chow on 23/5/2023.
//

import Foundation
import UIKit
import RxSwift

class AlbumViewController: UIViewController {
    public typealias ViewModel = AlbumViewModel
    private let _viewModel: ViewModel
    private let disposeBag = DisposeBag()
    
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
        view.backgroundColor = .red
        
        
        tabBarItem.image = UIImage.checkmark
    }
    
    func bindViewModel() {
        if let tabBarItemRxTitle = tabBarItem?.rx.title {
            _viewModel.output.tabbarTitle.drive(tabBarItemRxTitle).disposed(by: disposeBag)
        }
        
    }
}
