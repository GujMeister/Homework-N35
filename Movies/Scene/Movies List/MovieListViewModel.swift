//
//  MovieListViewModel.swift
//  Movies
//
//  Created by Luka Gujejiani on 04.06.24.
//

import Foundation
import SimpleNetworking

final class MovieListViewModel: ObservableObject {
    // MARK: Properties
    @Published var allMovies: [Movie] = []
    
    // MARK: Lifecycle
    init() {
        fetchMovies()
    }
    
    // MARK: Functions
    private func fetchMovies() {
        let dispatchGroup = DispatchGroup()
        
        //Fetching first 50 pages იმიტომ რომ სულ 44493 გვერდია :O
        for page in 1...50 {
            dispatchGroup.enter()
            let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=22392d65a7c9e67e5e3105aca487aec4&page=\(page)"
            WebService().fetchData(from: urlString, resultType: MovieResponse.self) { [weak self] data in
                switch data {
                case .success(let movies):
                        DispatchQueue.main.async {
                            self?.allMovies.append(contentsOf: movies.results)
                        }
                case .failure(let error):
                    print("Error fetching characters from page \(page): \(error)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("All movies fetched successfully.")
        }
    }
}
