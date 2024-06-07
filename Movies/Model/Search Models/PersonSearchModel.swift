//
//  PersonSearchModel.swift
//  Movies
//
//  Created by Luka Gujejiani on 08.06.24.
//

import Foundation

struct PersonSearchModel: Decodable {
    let results: [PersonResult]
}

struct PersonResult: Decodable {
    let id: Int
    let name: String
    let profilePath: String?
    let knownFor: [KnownFor]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePath = "profile_path"
        case knownFor = "known_for"
    }
}

struct KnownFor: Decodable {
    let id: Int
    let title: String?
    let originalTitle: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case originalTitle = "original_title"
    }
}
