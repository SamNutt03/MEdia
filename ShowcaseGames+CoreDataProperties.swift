//
//  ShowcaseGames+CoreDataProperties.swift
//  MEdia
//
//  Created by Sam Nuttall on 04/07/2025.
//
//

import Foundation
import CoreData


extension ShowcaseGames {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShowcaseGames> {
        return NSFetchRequest<ShowcaseGames>(entityName: "ShowcaseGames")
    }

    @NSManaged public var alreadyPlayed: Bool
    @NSManaged public var creator: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var overview: String?
    @NSManaged public var rating: Double
    @NSManaged public var releaseDate: String?
    @NSManaged public var showcasePosition: Int64
    @NSManaged public var title: String?

}

extension ShowcaseGames : Identifiable {

}
