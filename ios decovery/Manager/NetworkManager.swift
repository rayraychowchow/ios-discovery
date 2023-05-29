//
//  NetworkManager.swift
//  ios decovery
//
//  Created by Ray Chow on 29/5/2023.
//

import Foundation
import Alamofire
import RxSwift

// MARK: General network request setting
class NetworkManager {
    public static let instance = NetworkManager()
    public let manager = Alamofire.Session.default
    
    private init() {
        manager.session.configuration.timeoutIntervalForRequest = 5
    }
}
