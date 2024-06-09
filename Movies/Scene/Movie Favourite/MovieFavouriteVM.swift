//
//  MovieFavouriteVM.swift
//  Movies
//
//  Created by Luka Gujejiani on 08.06.24.
//

import SwiftUI
import SwiftData
import SimpleNetworking

final class MovieFavouriteVM: ObservableObject {
    @Published var movieDetails: [DetailInfo] = []

    func fetchMovieDetails(for movies: [Movie]) {
        let dispatchGroup = DispatchGroup()
        
        for movie in movies {
            dispatchGroup.enter()
            let urlString = "https://api.themoviedb.org/3/movie/\(movie.id)?api_key=22392d65a7c9e67e5e3105aca487aec4"
            WebService().fetchData(from: urlString, resultType: DetailInfo.self) { [weak self] data in
                switch data {
                case .success(let movie):
                    DispatchQueue.main.async {
                        self?.movieDetails.append(movie)
                    }
                case .failure(let error):
                    print("Error fetching details for movie ID \(movie.id): \(error)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("All movie details in favourites fetched successfully.")
        }
    }
}
