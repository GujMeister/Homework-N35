//
//  FavouriteMovies.swift
//  Movies
//
//  Created by Luka Gujejiani on 08.06.24.
//

import Foundation
import SwiftData

@Model
final class FavouriteGenre {
    @Attribute var id: Int?
    @Attribute var name: String

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

@Model
final class FavouriteMovie {
    @Attribute(.unique) var id: Int
    @Attribute var backdropPath: String?
    @Attribute var overview: String
    @Attribute var posterPath: String?
    @Attribute var releaseDate: String
    @Attribute var runtime: Int
    @Attribute var title: String
    @Attribute var voteAverage: Double
    @Relationship var genres: [FavouriteGenre] = []

    init(movie: DetailInfo) {
        self.id = movie.id ?? 0
        self.backdropPath = movie.backdropPath
        self.overview = movie.overview
        self.posterPath = movie.posterPath
        self.releaseDate = movie.releaseDate
        self.runtime = movie.runtime
        self.title = movie.title
        self.voteAverage = movie.voteAverage
        self.genres = movie.genres.map { FavouriteGenre(id: $0.id, name: $0.name) }
    }
}
