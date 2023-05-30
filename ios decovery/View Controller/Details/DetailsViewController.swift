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
import TinyConstraints

class DetailsViewController: UIViewController {
    public typealias ViewModel = DetailsViewModel
    private let _viewModel: ViewModel
    private let disposeBag = DisposeBag()
    
    private let collectionImageView = UIImageView()
    private let titleLabel = UILabel()
    private let artistNameLabel = UILabel()
    private let closeNavigationBarItem = UIBarButtonItem(title: "Close", style: .done, target: nil, action: nil)
    private let bookmarkNavigationBarItem = UIBarButtonItem(image: UIImage(named: "bookmark"), landscapeImagePhone: nil, style: .plain, target: nil, action: nil)
    private let bookmarkedNavigationBarItem = UIBarButtonItem(image: UIImage(named: "bookmarked"), landscapeImagePhone: nil, style: .plain, target: nil, action: nil)
    
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
    
    private func setupUI() {
        navigationController?.navigationBar.topItem?.leftBarButtonItem = closeNavigationBarItem
        navigationController?.navigationBar.topItem?.rightBarButtonItem = bookmarkNavigationBarItem
        
        view.backgroundColor = .white
        
        view.addSubview(collectionImageView)
        view.addSubview(titleLabel)
        view.addSubview(artistNameLabel)
        
        collectionImageView.do {
            $0.size(CGSize(width: 100, height: 100))
            $0.edgesToSuperview(excluding: LayoutEdge(arrayLiteral: [.bottom, .right]), usingSafeArea: true)
        }
                    
        titleLabel.do {
            $0.textColor = .black
            $0.leftToRight(of: collectionImageView)
            $0.numberOfLines = 2
            $0.edgesToSuperview(excluding: LayoutEdge(arrayLiteral: [.left, .bottom]), usingSafeArea: true)
        }
        
        artistNameLabel.do {
            $0.textColor = .black
            $0.leftToRight(of: collectionImageView)
            $0.topToBottom(of: titleLabel)
            $0.numberOfLines = 2
            $0.rightToSuperview()
            $0.bottom(to: collectionImageView)
            $0.height(to: titleLabel)
        }
    }
    
    private func bindViewModel() {
        disposeBag.insert([
            closeNavigationBarItem.rx.tap.bind(to: _viewModel.input.onCloseTapped),
            bookmarkNavigationBarItem.rx.tap.bind(to: _viewModel.input.onBookmarkButtonTapped),
            bookmarkedNavigationBarItem.rx.tap.bind(to: _viewModel.input.onBookmarkButtonTapped),
            _viewModel.output.closeButtonTitle.drive(closeNavigationBarItem.rx.title),
            _viewModel.output.isBookmarked.withUnretained(self).do(onNext: { this, isBookmarked in
                this.navigationController?.navigationBar.topItem?.rightBarButtonItem = isBookmarked ? this.bookmarkedNavigationBarItem : this.bookmarkNavigationBarItem
            }).subscribe(),
            _viewModel.output.collectionImage.drive(collectionImageView.rx.image),
            _viewModel.output.collectionTitle.drive(titleLabel.rx.text),
            _viewModel.output.collectionArtistName.drive(artistNameLabel.rx.text)
        ])
    }
}
