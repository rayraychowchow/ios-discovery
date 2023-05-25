//
//  BaseTableViewCell.swift
//  ios decovery
//
//  Created by Ray Chow on 25/5/2023.
//


import Foundation
import UIKit
import RxSwift

class BaseTableViewCell: UITableViewCell {
    // DisposeBag for subscribing observable from cell
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //Replace a new dispose bag for next time
        disposeBag = DisposeBag()
    }
}

