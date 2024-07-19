//
//  MockImageLoader.swift
//  CatBreedsBookTests
//
//  Created by Vitaliy Bal on 19.07.2024.
//

import Foundation
import UIKit

@testable import CatBreedsBook

class MockImageLoader: ImageLoaderProtocol {
    
    var images: [URL: UIImage] = [:]
    var error: Error?

    func loadImage(from url: URL) async -> UIImage? {
        if let error = error {
            return nil
        } else {
            return images[url]
        }
    }
}
