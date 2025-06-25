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
    let id: Int
    let title: String
    let releaseDate: String?
    let posterPath: String?
    let overview: String?
    let rating: Double?
    let credits: Credits?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case overview = "overview"
        case rating = "vote_average"
        case credits
    }
    
    struct Credits: Codable {
        let crew: [CrewMember]
    }

    struct CrewMember: Codable {
        let job: String
        let name: String
    }
    
    var fullPosterURL: URL? {
            guard let path = posterPath else { return nil }
            return URL(string: "https://image.tmdb.org/t/p/w200\(path)")
        }
    
    var director: String? {
        return credits?.crew.first(where: { $0.job == "Director" })?.name
    }
}





