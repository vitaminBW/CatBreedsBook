//
//  MOBreed+CoreDataClass.swift
//  CatBreedsBook
//
//  Created by Vitaliy Bal on 18.07.2024.
//
//

import Foundation
import CoreData

@objc(MOBreed)
public class MOBreed: NSManagedObject {

}

extension MOBreed {
    
    func toBreed() -> Breed {
        let id = self.id ?? ""
        let name = self.name ?? ""
        let breedDescription = self.breedDescription ?? ""
        let photos = self.photos ?? []

        return Breed(
            id: id,
            name: name,
            breedDescription: breedDescription,
            imageURLs: Array(photos).compactMap { $0.url }
        )
    }
}
