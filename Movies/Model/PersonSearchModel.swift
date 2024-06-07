//
//  PersonSearchModel.swift
//  Movies
//
//  Created by Luka Gujejiani on 08.06.24.
//

import Foundation

// MARK: - PersonSearchModel
struct PersonSearchModel: Codable {
    let page: Int
    let results: [PersonResult]
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - PersonResult
struct PersonResult: Codable {
    let id: Int
    let name: String
    let popularity: Double
    let profilePath: String?
    let knownFor: [KnownFor]

    enum CodingKeys: String, CodingKey {
        case id, name, popularity
        case profilePath = "profile_path"
        case knownFor = "known_for"
    }
}

// MARK: - KnownFor
struct KnownFor: Codable {
    let id: Int
    let title: String?
    let originalTitle: String?
    let mediaType: String
    let posterPath: String?
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case originalTitle = "original_title"
        case mediaType = "media_type"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
