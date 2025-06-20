//
//  ShowcaseMovies+CoreDataProperties.swift
//  MEdia
//
//  Created by Sam Nuttall on 20/06/2025.
//
//

import Foundation
import CoreData


extension ShowcaseMovies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShowcaseMovies> {
        return NSFetchRequest<ShowcaseMovies>(entityName: "ShowcaseMovies")
    }

    @NSManaged public var title: String?
    @NSManaged public var overview: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var director: String?
    @NSManaged public var showcasePosition: Int64

}

extension ShowcaseMovies : Identifiable {

}
