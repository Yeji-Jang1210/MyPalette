//
//  SavedPhoto.swift
//  MyPalette
//
//  Created by 장예지 on 7/26/24.
//

import Foundation
import RealmSwift

class SavedPhoto: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var savedDate: Date
    
    @Persisted var photoId: String
    @Persisted var likes: Int
    @Persisted var width: Int
    @Persisted var height: Int
    @Persisted var smallImageUrl: String
    @Persisted var rawImageUrl: String
    @Persisted var createdAt: String
    
    @Persisted var userProfileImage: String
    @Persisted var name: String
    
    convenience init(_ photo: Photo) {
        self.init()
        self.savedDate = Date()
        self.photoId = photo.id
        self.likes = photo.likes
        self.width = photo.width
        self.height = photo.height
        self.smallImageUrl = photo.urls.small
        self.rawImageUrl = photo.urls.raw
        self.createdAt = photo.createdAt
        self.userProfileImage = photo.user.profileImage.medium
        self.name = photo.user.name
    }
}
