//
//  SettingsTableViewCell.swift
//  ios decovery
//
//  Created by Ray Chow on 25/5/2023.
//

import Foundation
import UIKit
import TinyConstraints
import RxSwift

class SettingsTableViewCell: BaseTableViewCell, CustomCellable {
    static var reuseId: String = "SettingsTableViewCell"
    
    private let titleLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(titleLabel)
        titleLabel.do { label in
            label.centerYToSuperview()
            label.leftToSuperview(offset: 8)
            label.textColor = .label
        }
    }
    
    func setupCell(languageSetting: LanguageSetting) {
        titleLabel.text = languageSetting.title
        backgroundColor = .systemBackground
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
