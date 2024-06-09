//
//  MoviesDetailsModel.swift
//  Movies
//
//  Created by Luka Gujejiani on 07.06.24.
//

import Foundation

struct DetailInfo: Decodable, Identifiable {
    let id = UUID()
    let backdropPath: String?
    let genres: [Genre]
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let runtime: Int
    let title: String
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genres
        case overview
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
