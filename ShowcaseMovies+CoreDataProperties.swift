//
//  ShowcaseMovies+CoreDataProperties.swift
//  MEdia
//
//  Created by Sam Nuttall on 03/07/2025.
//
//

import Foundation
import CoreData


extension ShowcaseMovies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShowcaseMovies> {
        return NSFetchRequest<ShowcaseMovies>(entityName: "ShowcaseMovies")
    }

    @NSManaged public var director: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var overview: String?
    @NSManaged public var rating: Double
    @NSManaged public var releaseDate: String?
    @NSManaged public var showcasePosition: Int64
    @NSManaged public var title: String?
    @NSManaged public var alreadyWatched: Bool

}

extension ShowcaseMovies : Identifiable {

}
