//
//  Photo.swift
//  MyPalette
//
//  Created by 장예지 on 7/24/24.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let likes: Int
    let width: Int
    let height: Int
    let urls: PhotoURL
    let createdAt: String
    let user: PhotoUser
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id, likes, width, height, urls, user
    }
    
    var createdDateText: String? {
        guard let date = createdAt.convertStringToDate(format: .iso8601) else { return nil }
        return date.convertDateToString(format: .created)
    }
    
    var sizeText: String {
        return "\(width) x \(height)"
    }
    
    var userProfileImageName: String {
        return "\(id)_\(user.name)"
    }
}

struct PhotoURL: Decodable{
    let raw: String
    let small: String
}

struct PhotoUser: Decodable {
    let profileImage: ProfileImage
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
        case name
    }
}

struct ProfileImage: Decodable {
    let medium: String
}
