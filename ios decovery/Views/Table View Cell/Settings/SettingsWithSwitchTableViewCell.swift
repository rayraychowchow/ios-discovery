//
//  SettingsWithSwitchTableViewCell.swift
//  ios decovery
//
//  Created by Ray Chow on 25/5/2023.
//

import Foundation
import UIKit
import TinyConstraints
import RxSwift
import RxCocoa

class SettingsWithSwitchTableViewCell: BaseTableViewCell, CustomCellable {
    static var reuseId: String = "SettingsWithSwitchTableViewCell"
    
    private let titleLabel = UILabel()
    let switchButton = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(titleLabel)
        titleLabel.do { label in
            label.centerYToSuperview()
            label.leftToSuperview(offset: 8)
            label.textColor = .black
        }
        
        addSubview(switchButton)
        switchButton.do { switchBtn in
            switchBtn.centerYToSuperview()
            switchBtn.rightToSuperview(offset: -8)
        }
    }
    
    func setupCell(darkModeSetting: DarkModeSetting) {
        titleLabel.text = darkModeSetting.title
        backgroundColor = .white
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
