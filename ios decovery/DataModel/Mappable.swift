//
//  Mappable.swift
//  ios decovery
//
//  Created by Ray Chow on 29/5/2023.
//
import Foundation
import SwiftyJSON

protocol Mappable {
    static func map(with json: JSON) -> Self
}

