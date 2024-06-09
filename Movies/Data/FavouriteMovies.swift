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
    
    init(movieID: Int = 0) {
        self.movieID = movieID
    }
}
