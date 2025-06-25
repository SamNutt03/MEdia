//
//  ShowcaseMovies+CoreDataProperties.swift
//  MEdia
//
//  Created by Sam Nuttall on 25/06/2025.
//
//

import Foundation
import CoreData


extension ShowcaseMovies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShowcaseMovies> {
        return NSFetchRequest<ShowcaseMovies>(entityName: "ShowcaseMovies")
    }

    @NSManaged public var imageURL: String?
    @NSManaged public var overview: String?
    @NSManaged public var showcasePosition: Int64
    @NSManaged public var title: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var rating: Double
    @NSManaged public var director: String?

}

extension ShowcaseMovies : Identifiable {

}
