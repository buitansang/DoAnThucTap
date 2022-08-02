//
//  APIController.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 24/07/2022.
//


import Foundation
import Alamofire

typealias ResponseClosure<T: Decodable> = (_ error: String?, _ data: T?) -> Void

struct APIController {
    static func request<T: Decodable>(_ responseType: T.Type, _ manager: APIManager, params: Parameters? = nil, headers: HTTPHeaders? = nil, completion: @escaping ResponseClosure<T>) {
        print("URL REQUEST: \(manager.url)")
        AF.request(manager.url, method: manager.method, parameters: params, encoding: manager.encoding, headers: headers).responseData { responseData in
            switch responseData.result {
            case .success(let data):
                JSONDecoder.decode(responseType, from: data) { error, reponse in
                    completion(nil, reponse)
                }
            case .failure(let error):
                completion(error.localizedDescription, nil)
            }
        }
    }
}
