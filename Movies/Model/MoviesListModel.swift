//
//  MoviesListModel.swift
//  Movies
//
//  Created by Luka Gujejiani on 04.06.24.
//

import Foundation

//ვიცი რომ ბევრი რამე არ მჭირდება მაგრამ დავტოვებ იქნებ შემდეგ დავალებებში დამჭირდეს <3 ცოტა მახინჯოა, მეც არ მომწონს მარა futureproofing მსხვერპლს მოითხოვსო ნათქვამია

struct MovieResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Only using: ID, releaseDate, PosterPath, title, voteAverage, voteCount
struct Movie: Codable, Identifiable, Hashable {
//    let adult: Bool
    let backdropPath: String?
    let genreIds: [Int]
    let id: Int
//    let originalLanguage: String
//    let originalTitle: String
    let overview: String
//    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let title: String
//    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
//        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
//        case originalLanguage = "original_language"
//        case originalTitle = "original_title"
        case overview
//        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
//        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
