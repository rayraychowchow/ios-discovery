//
//  CustomCellable.swift
//  ios decovery
//
//  Created by Ray Chow on 25/5/2023.
//

import Foundation
// MARK: For UITableViewCell and UICollectionViewCell to define reuse-identifier
protocol CustomCellable {
    static var reuseId: String { get }
}
