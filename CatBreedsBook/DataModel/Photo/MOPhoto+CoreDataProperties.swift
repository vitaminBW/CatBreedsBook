//
//  MOPhoto+CoreDataProperties.swift
//  CatBreedsBook
//
//  Created by Vitaliy Bal on 18.07.2024.
//
//

import Foundation
import CoreData


extension MOPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOPhoto> {
        return NSFetchRequest<MOPhoto>(entityName: "MOPhoto")
    }

    @NSManaged public var url: String?
    @NSManaged public var breed: MOBreed?

}

extension MOPhoto : Identifiable {

}
