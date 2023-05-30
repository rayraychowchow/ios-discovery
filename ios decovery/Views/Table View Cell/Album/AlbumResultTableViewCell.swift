//
//  AlbumResultTableViewCell.swift
//  ios decovery
//
//  Created by Ray Chow on 29/5/2023.
//

import Foundation
import UIKit
import TinyConstraints

class AlbumResultTableViewCell: BaseTableViewCell, CustomCellable {
    static var reuseId: String = "AlbumResultTableViewCell"
    
    private let titleLabel = UILabel()
    let bookmarkButton = UIButton(type: .custom)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        selectionStyle = .none
        contentView.addSubview(titleLabel)
        titleLabel.do { label in
            label.centerYToSuperview()
            label.leftToSuperview(offset: 8)
            label.textColor = .black
            label.height(min: 60)
            label.topToSuperview()
            label.bottomToSuperview()
            label.numberOfLines = 2
            label.adjustsFontSizeToFitWidth = true
        }
        
        contentView.addSubview(bookmarkButton)
        bookmarkButton.do {
            $0.leftToRight(of: titleLabel, offset: 8)
            $0.rightToSuperview(offset: -8)
            $0.centerYToSuperview()
            $0.setImage(UIImage(named: "bookmark"), for: .normal)
            $0.width(48)
            $0.height(48)
        }
    }
    
    func setupCell(ituneCollection: iTunesCollection, isBookmarked: Bool) {
        titleLabel.text = ituneCollection.collectionName ?? ituneCollection.artistName ?? ""
        bookmarkButton.setImage(isBookmarked ? UIImage(named: "bookmarked") : UIImage(named: "bookmark"), for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        bookmarkButton.setImage(UIImage(named: "bookmark"), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
