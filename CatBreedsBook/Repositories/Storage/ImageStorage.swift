//
//  ImageStorage.swift
//  CatBreedsBook
//
//  Created by Vitaliy Bal on 19.07.2024.
//

import Foundation
import UIKit

protocol ImageStorage {
    
    func loadImage(forKey key: String) -> UIImage?
    func saveImage(_ image: UIImage, forKey key: String)
    func removeImage(forKey key: String)
    func clearStorage()
}

class InMemoryImageStorage: ImageStorage {
    
    private let cache = NSCache<NSString, UIImage>()
    
    init(limit: Int) {
        cache.totalCostLimit = limit
    }
    
    func loadImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func saveImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func removeImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func clearStorage() {
        cache.removeAllObjects()
    }
}

class DiskImageStorage: ImageStorage {
    
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init() {
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = urls[0]
    }
    
    func loadImage(forKey key: String) -> UIImage? {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        guard let data = try? Data(contentsOf: fileURL),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
    
    func saveImage(_ image: UIImage, forKey key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        guard let data = image.jpegData(compressionQuality: 0.9) else { return }
        try? data.write(to: fileURL)
    }
    
    func removeImage(forKey key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        try? fileManager.removeItem(at: fileURL)
    }
    
    func clearStorage() {
        if let files = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil) {
            for file in files {
                try? fileManager.removeItem(at: file)
            }
        }
    }
}

class CombinedImageStorage: ImageStorage {
    
    private let memoryStorage: InMemoryImageStorage
    private let diskStorage: DiskImageStorage
    
    init(memoryLimit: Int) {
        self.memoryStorage = InMemoryImageStorage(limit: memoryLimit)
        self.diskStorage = DiskImageStorage()
    }
    
    func loadImage(forKey key: String) -> UIImage? {
        if let image = memoryStorage.loadImage(forKey: key) {
            return image
        }
        if let image = diskStorage.loadImage(forKey: key) {
            memoryStorage.saveImage(image, forKey: key)
            return image
        }
        return nil
    }
    
    func saveImage(_ image: UIImage, forKey key: String) {
        memoryStorage.saveImage(image, forKey: key)
        diskStorage.saveImage(image, forKey: key)
    }
    
    func removeImage(forKey key: String) {
        memoryStorage.removeImage(forKey: key)
        diskStorage.removeImage(forKey: key)
    }
    
    func clearStorage() {
        memoryStorage.clearStorage()
        diskStorage.clearStorage()
    }
}
