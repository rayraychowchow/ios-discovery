//
//  NetworkService.swift
//  ios decovery
//
//  Created by Ray Chow on 23/5/2023.
//

import Foundation
import SwiftyJSON
import Alamofire
import RxSwift

// MARK: A generic network service for http request which response JSON
class NetworkService {
    
    // MARK: HTTP GET
    func getDecodableReponse<T:Decodable>(url:String, params:[String:Any]? = nil, requireHeader: Bool = true, encoding: ParameterEncoding = JSONEncoding.default, dateFormatter: DateFormatter? = nil) -> Single<T> {
        return request(url: url, params: params, method: .get, encoding: encoding, requireHeader: requireHeader).observe(on: MainScheduler.instance)
    }
    
    // MARK: An overall function for http request
     private func request<T:Decodable>(url:String, params:[String:Any]? = nil, method: HTTPMethod = .get, encoding: ParameterEncoding, requireHeader: Bool = true, dateFormatter: DateFormatter? = nil) -> Single<T> {
        let request = NetworkManager.instance.manager.request(url, method: method, parameters: params, encoding: encoding, headers: nil)
        
        return Single<T>.create{ [weak self] single in
            guard let this = self else{ return Disposables.create{
                request.cancel()
            } }
            
            let decoder = JSONDecoder()
            
            
            if let dateFormatter {
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
            }
            
            request.responseDecodable(of: T.self, decoder: decoder) { response in
                switch response.result {
                case .success(let result):
                    single(.success(result))
                    break
                case .failure(let error):
                    single(.failure(error))
                    break
                }
            }
            return Disposables.create{
                request.cancel()
            }
        }
    }
}
