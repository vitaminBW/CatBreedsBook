//
//  Photo.swift
//  CatBreedsBook
//
//  Created by Vitaliy Bal on 18.07.2024.
//

import Foundation

struct Photo: Identifiable, Codable {
    
    var id = UUID().uuidString
    let url: String
    let breedID: String
}
