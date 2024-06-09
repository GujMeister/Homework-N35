//
//  MoviesApp.swift
//  Movies
//
//  Created by Luka Gujejiani on 04.06.24.
//

import SwiftUI
import SwiftData

@main
struct MoviesApp: App {
    var body: some Scene {
        WindowGroup {
            MainScene()
        }
        .modelContainer(for: FavouriteMovie.self)
    }
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
