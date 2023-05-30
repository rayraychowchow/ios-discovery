//
//  BookmarkTableViewCell.swift
//  ios decovery
//
//  Created by Ray Chow on 30/5/2023.
//

import Foundation
import UIKit
import TinyConstraints

class BookmarkTableViewCell: BaseTableViewCell, CustomCellable {
    static var reuseId: String = "BookmarkTableViewCell"
    
    private let titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        backgroundColor = .systemBackground
        selectionStyle = .none
        titleLabel.do {
            $0.textColor = .label
            $0.height(min: 60)
            $0.edgesToSuperview(insets: TinyEdgeInsets(top: 0, left: 8, bottom: 0, right: -8))
            $0.numberOfLines = 2
            $0.adjustsFontSizeToFitWidth = true
        }
    }
    
    func setupCell(object: iTunesCollectionObject) {
        titleLabel.text = object.collectionName
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
