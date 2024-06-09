//
//  MoviesListModel.swift
//  Movies
//
//  Created by Luka Gujejiani on 04.06.24.
//

import Foundation

struct MovieResponse: Decodable {
    let results: [Movie]
}

struct Movie: Decodable, Identifiable, Hashable {
    let id: Int
    let posterPath: String?
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case title
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
