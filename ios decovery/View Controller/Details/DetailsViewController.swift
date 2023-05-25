//
//  DetailsViewController.swift
//  ios decovery
//
//  Created by Ray Chow on 25/5/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class DetailsViewController: UIViewController {
    public typealias ViewModel = DetailsViewModel
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
        title = "Details"
        view.backgroundColor = .white
        
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: nil, action: nil)
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem?.rx.tap.bind(to: _viewModel.input.onCloseTapped).disposed(by: disposeBag)
    }
}
