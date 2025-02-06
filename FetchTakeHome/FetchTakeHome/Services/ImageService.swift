//
//  ImageService.swift
//  FetchTakeHome
//
//  Created by Brian Liew on 1/31/25.
//

import Foundation
import UIKit

class ImageService {
    
    static let shared = ImageService()
    static let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    
    static func fetchImage(urlString: String, id: String) async throws -> UIImage {
        if let image = self.getImageFromCache(for: id) {
            return image
        }
        
        let image = try await NetworkService.fetchImage(urlString: urlString)
        
        self.saveImageToCache(id: id, image: image)
        
        return image
    }
    
    static func getImageURLFromCache(for id: String) -> URL {
        return cacheDirectory.appendingPathComponent("\(id).jpg")
    }
    
    static func getImageFromCache(for id: String) -> UIImage? {
        let imageURL = self.getImageURLFromCache(for: id)
        
        if let data = try? Data(contentsOf: imageURL),
           let image = UIImage(data: data) {
            return image
        }
        
        return nil
    }
    
    static func saveImageToCache(id: String, image: UIImage) -> Void {
        let imageURL = cacheDirectory.appendingPathComponent("\(id).jpg")
        if let data = image.jpegData(compressionQuality: 1.0) {
            try? data.write(to: imageURL)
        }
    }
    
}
