//
//  String+Extension.swift
//  MyPalette
//
//  Created by 장예지 on 7/26/24.
//

import UIKit

extension String {
    func fetchImage(completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: self) else {
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }

        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    completion(image)
                }
            } catch {
                print("Error fetching image: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}

