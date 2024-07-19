//
//  MOBreed+CoreDataProperties.swift
//  CatBreedsBook
//
//  Created by Vitaliy Bal on 18.07.2024.
//
//

import Foundation
import CoreData


extension MOBreed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOBreed> {
        return NSFetchRequest<MOBreed>(entityName: "MOBreed")
    }

    @NSManaged public var breedDescription: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var photos: Set<MOPhoto>?

}

// MARK: Generated accessors for photos
extension MOBreed {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: MOPhoto)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: MOPhoto)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}

extension MOBreed : Identifiable {

}
