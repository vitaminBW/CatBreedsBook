//
//  Breed.swift
//  CatBreedsBook
//
//  Created by Vitaliy Bal on 18.07.2024.
//

import Foundation

struct Breed: Identifiable, Codable {
    
    let id: String
    let name: String
    let breedDescription: String
    let imageURLs: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case breedDescription = "description"
        case imageURLs = "image_url"
    }
}
