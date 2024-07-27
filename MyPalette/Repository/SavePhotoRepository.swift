//
//  SavePhotoRepository.swift
//  MyPalette
//
//  Created by 장예지 on 7/26/24.
//

import Foundation
import RealmSwift

protocol SavePhotoRepositoryProtocol {
    func savePhoto(_ photo: Photo)
    func fetchPhotos() -> Results<SavedPhoto>
    func deletePhoto(_ photoId: String)
    func deleteAll(completion: @escaping (Bool) -> Void)
}

final class SavePhotoRepository: SavePhotoRepositoryProtocol {
    
    static let shared = SavePhotoRepository()
    
    private init(){}
    
    private let realm = try! Realm()
    
    func fetchPhotos() -> Results<SavedPhoto> {
        return realm.objects(SavedPhoto.self)
    }
    
    func savePhoto(_ photo: Photo) {
        let savedPhoto = SavedPhoto(photo)
        do {
            try realm.write {
                realm.add(savedPhoto)
            }
        } catch {
            print("Error")
        }
    }

    func deletePhoto(_ photoId: String) {
        let item = realm.objects(SavedPhoto.self).where {
            $0.photoId == photoId
        }
        
        FileManager.removeImageFromDocument(filename: photoId)
        try! realm.write{
            realm.delete(item)
        }
    }
    
    func findPhoto(_ photoId: String) -> Bool {
        let item = realm.objects(SavedPhoto.self).where {
            $0.photoId == photoId
        }
        
        return !item.isEmpty ? true : false
    }
    
    func deleteAll(completion: @escaping (Bool) -> Void) {
        do {
            try realm.write{
                realm.deleteAll()
                completion(true)
            }
        } catch {
            completion(false)
        }
    }
    
}
