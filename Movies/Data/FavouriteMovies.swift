//
//  FavouriteMovies.swift
//  Movies
//
//  Created by Luka Gujejiani on 08.06.24.
//

import Foundation
import SwiftData

@Model
class FavouriteMovie {
    @Attribute var movieID: Int
    @Attribute var posterPath: String?
    @Attribute var title: String

    init(movie: Movie) {
        self.movieID = movie.id
        self.posterPath = movie.posterPath
        self.title = movie.title
    }
}

//@Model
//class FavouriteMovie {
//    @Attribute var movieID: Int
//    
//    init(movieID: Int = 0) {
//        self.movieID = movieID
//    }
//}
