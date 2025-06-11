//
//  BedroomLayers+CoreDataProperties.swift
//  MEdia
//
//  Created by Sam Nuttall on 11/06/2025.
//
//

import Foundation
import CoreData


extension BedroomLayers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BedroomLayers> {
        return NSFetchRequest<BedroomLayers>(entityName: "BedroomLayers")
    }

    @NSManaged public var bookshelf: String?
    @NSManaged public var controller: String?
    @NSManaged public var frames: String?
    @NSManaged public var plant: String?
    @NSManaged public var room: String?
    @NSManaged public var rug: String?
    @NSManaged public var tv: String?
    @NSManaged public var vinyl: String?
    @NSManaged public var window: String?

}

extension BedroomLayers : Identifiable {

}
