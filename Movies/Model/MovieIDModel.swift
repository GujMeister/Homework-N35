//
//  MovieIDModel.swift
//  Movies
//
//  Created by Luka Gujejiani on 07.06.24.
//

import Foundation

final class MovieID {
    struct MovieResponse: Decodable {
        let results: [Movie]
    }
    
    struct Movie: Decodable, Identifiable, Hashable {
        let id: Int
    }
}
