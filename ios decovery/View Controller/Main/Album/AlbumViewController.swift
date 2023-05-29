//
//  AlbumViewController.swift
//  ios decovery
//
//  Created by Ray Chow on 23/5/2023.
//

import Foundation
import UIKit
import RxSwift
import Then
import TinyConstraints

class AlbumViewController: UIViewController {
    public typealias ViewModel = AlbumViewModel
    private let _viewModel: ViewModel
    private let disposeBag = DisposeBag()
    
    private let testButton = UIButton()
    
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
        view.backgroundColor = .red
        view.addSubview(testButton)
        
        testButton.do {
            $0.setTitle("show details", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.centerInSuperview()
        }
    }
    
    func bindViewModel() {
        disposeBag.insert([
            testButton.rx.tap.bind(to: _viewModel.input.onTestButtonTapped),
            rx.viewWillAppear.take(1).bind(to: _viewModel.input.onReload),
            _viewModel.output.navigationTitle.drive(rx.title)
        ])
        
            
        
    }
}
