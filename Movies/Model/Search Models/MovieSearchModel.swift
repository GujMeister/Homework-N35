//
//  MovieSearchModel.swift
//  Movies
//
//  Created by Luka Gujejiani on 07.06.24.
//

import Foundation

final class Search {
    struct SearchDetailInfo: Decodable {
        let genres: [Genre]
        let posterPath: String?
        let releaseDate: String
        let runtime: Int
        let title: String
        let voteAverage: Double
        
        enum CodingKeys: String, CodingKey {
            case genres
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case runtime
            case title
            case voteAverage = "vote_average"
        }
    }
    
    struct Genre: Decodable {
        let id: Int
        let name: String
    }
}
