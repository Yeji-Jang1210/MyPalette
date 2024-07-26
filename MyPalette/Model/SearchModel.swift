//
//  SearchModel.swift
//  MyPalette
//
//  Created by 장예지 on 7/25/24.
//

import Foundation

struct SearchParameter {
    let query: String
    let page: Int
    let orderBy: String
}

struct SearchResponse: Decodable {
    let total: Int
    let totalPages: Int
    let results: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case total, results
    }
    
}
