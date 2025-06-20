//
//  APIResultStructs.swift
//  MEdia
//
//  Created by Sam Nuttall on 20/06/2025.
//

import Foundation



struct TMDbSearchResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let title: String
    let releaseDate: String?
    let posterPath: String?
    let overview: String?

    enum CodingKeys: String, CodingKey {
        case title
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case overview = "overview"
    }
    
    var fullPosterURL: URL? {
            guard let path = posterPath else { return nil }
            return URL(string: "https://image.tmdb.org/t/p/w200\(path)")
        }
}





