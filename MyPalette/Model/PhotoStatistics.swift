//
//  PhotoStatistics.swift
//  MyPalette
//
//  Created by 장예지 on 7/25/24.
//

import Foundation

struct PhotoStatistics: Decodable {
    let id: String
    let downloads: Downloads
    let views: Views
}

struct Downloads: Decodable {
    let total: Int
    let historical: Historical
}


struct Views: Decodable {
    let total: Int
    let historical: Historical
}

struct Historical: Decodable {
    let values: [Values]
}

struct Values: Decodable {
    let date: String
    let value: Int
}
