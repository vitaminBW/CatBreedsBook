//
//  ImageRepository.swift
//  CatBreedsBook
//
//  Created by Vitaliy Bal on 18.07.2024.
//

import Foundation
import UIKit
import Combine

protocol ImageRepositoryProtocol {
    
    func loadImage(from url: URL) async -> UIImage?
}

class InMemoryImageRepository: ImageRepositoryProtocol {
    
    private let storage: ImageStorage
    
    init(storage: ImageStorage) {
        self.storage = storage
    }
    
    func loadImage(from url: URL) async -> UIImage? {
        let key = url.lastPathComponent
        return storage.loadImage(forKey: key)
    }
}

class DiskImageRepository: ImageRepositoryProtocol {
    
    private let storage: ImageStorage
    
    init(storage: ImageStorage) {
        self.storage = storage
    }
    
    func loadImage(from url: URL) async -> UIImage? {
        let key = url.lastPathComponent
        return storage.loadImage(forKey: key)
    }
}

class CombinedImageRepository: ImageRepositoryProtocol {
    
    private let storage: ImageStorage
    
    init(storage: ImageStorage) {
        self.storage = storage
    }
    
    func loadImage(from url: URL) async -> UIImage? {
        let key = url.lastPathComponent
        if let image = storage.loadImage(forKey: key) {
            return image
        }
        
        let task = Task { () -> UIImage? in
            guard let (data, _) = try? await URLSession.shared.data(from: url),
                  let image = UIImage(data: data) else {
                return nil
            }
            storage.saveImage(image, forKey: key)
            return image
        }
        
        return await task.value
    }
}
