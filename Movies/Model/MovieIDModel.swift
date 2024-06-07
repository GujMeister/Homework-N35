//
//  MovieIDModel.swift
//  Movies
//
//  Created by Luka Gujejiani on 07.06.24.
//

import Foundation

final class MovieID {
    struct MovieResponse: Codable {
        let results: [Movie]
    }
    
    // MARK: - Only using: ID, releaseDate, PosterPath, title, voteAverage, voteCount
    struct Movie: Codable, Identifiable, Hashable {
        let id: Int
    }
}
