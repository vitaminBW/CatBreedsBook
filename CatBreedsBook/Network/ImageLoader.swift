//
//  ImageLoader.swift
//  CatBreedsBook
//
//  Created by Vitaliy Bal on 19.07.2024.
//

import Foundation
import UIKit

protocol ImageLoaderProtocol {
    
    func loadImage(from url: URL) async -> UIImage?
}

actor ImageLoader: ImageLoaderProtocol {
    
    private let imageRepository: ImageRepositoryProtocol
    
    init(imageRepository: ImageRepositoryProtocol) {
        self.imageRepository = imageRepository
    }
    
    func loadImage(from url: URL) async -> UIImage? {
        return await imageRepository.loadImage(from: url)
    }
}
