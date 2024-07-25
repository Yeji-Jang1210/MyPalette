//
//  APIService.swift
//  MyPalette
//
//  Created by 장예지 on 7/24/24.
//

import Foundation
import Alamofire

enum NetworkResult<T> {
    case success(T)
    case error(AFError)
}

final class APIService {
    
    static var shared = APIService()
    
    private init(){}
    
    func networking<T: Decodable>(api: APIManager, of: T.Type, completion: @escaping (NetworkResult<T>) -> ()){
        guard let url = URL(string: api.url) else { return }
        AF.request(url,
                   method: api.method,
                   parameters: api.parameters,
                   encoding: URLEncoding.queryString,
                   headers: api.headers).responseDecodable(of: T.self){ response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.error(error))
            }
        }
    }
}
