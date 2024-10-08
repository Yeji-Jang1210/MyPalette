//
//  APIManager.swift
//  MyPalette
//
//  Created by 장예지 on 7/24/24.
//

import Foundation
import Alamofire

enum APIManager {
    case topic(id: String)
    case statistics(id: String)
    case search(param: SearchParameter)
    case random
    case getPhoto(id: String)
}

extension APIManager {
    
    var baseURL: String {
        return "https://api.unsplash.com"
    }
    
    var url: String {
        return baseURL + self.path
    }
    
    var path: String {
        switch self {
        case .topic(let id):
            return "/topics/\(id)/photos"
        case .statistics(let id):
            return "/photos/\(id)/statistics"
        case .search:
            return "/search/photos"
        case .random:
            return "/photos/random"
        case .getPhoto(let id):
            return "/photos/\(id)"
        }
    }
    
    var headers: HTTPHeaders {
        return [
            "Authorization" : "Client-ID \(APIInfo.accessKey)"
        ]
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters? {
        switch self {
        case .search(let param):
            return [
                "query": param.query,
                "order_by": param.orderBy,
                "page": param.page,
                "per_page": 20
            ]
        case .random:
            return [
                "orientation": "portrait",
                "count": 10
            ]
        default:
            return nil
        }
    }
}
