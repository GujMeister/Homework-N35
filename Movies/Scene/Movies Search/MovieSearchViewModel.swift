//
//  MovieSearchViewModel.swift
//  Movies
//
//  Created by Luka Gujejiani on 05.06.24.
//

import Foundation
import SimpleNetworking

final class MovieSearchViewModel: ObservableObject {
    // MARK: Properties
    @Published var movieIDList: [Int] = []
    @Published var movieSearchDetails: [Search.SearchDetailInfo] = []
    @Published var movieNameSearchDetails: [Search.SearchDetailInfo] = []
    private var allMovies: [Search.SearchDetailInfo] = []
    
    init() {
        fetchMovies()
    }
    
    func searchMovies(query: String, category: String) {
        if query.isEmpty {
            movieSearchDetails = allMovies
        } else {
            movieSearchDetails = allMovies.filter { movie in
                switch category {
                case "Name":
                    return movie.title.lowercased().contains(query.lowercased())
                case "Genre":
                    return movie.genres.contains { $0.name.lowercased().contains(query.lowercased()) }
                case "Year":
                    return movie.releaseDate.contains(query)
                default:
                    return false
                }
            }
        }
    }
    
    // MARK: - Genre Searching (No query search so had to bruteforce)
    private func fetchMovies() {
        let dispatchGroup = DispatchGroup()
        
        for page in 1...100 {
            dispatchGroup.enter()
            let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=22392d65a7c9e67e5e3105aca487aec4&page=\(page)"
            WebService().fetchData(from: urlString, resultType: MovieID.MovieResponse.self) { [weak self] data in
                switch data {
                case .success(let movieResponse):
                    DispatchQueue.main.async {
                        self?.movieIDList.append(contentsOf: movieResponse.results.map { $0.id })
                    }
                case .failure(let error):
                    print("Error fetching characters from page \(page): \(error)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("All movie IDs fetched successfully.")
            self.fetchMovieDetails()
        }
    }
    
    private func fetchMovieDetails() {
        let dispatchGroup = DispatchGroup()
        
        for movieID in movieIDList {
            dispatchGroup.enter()
            let urlString = "https://api.themoviedb.org/3/movie/\(movieID)?api_key=22392d65a7c9e67e5e3105aca487aec4"
            WebService().fetchData(from: urlString, resultType: Search.SearchDetailInfo.self) { [weak self] data in
                switch data {
                case .success(let movieDetail):
                    DispatchQueue.main.async {
                        self?.allMovies.append(movieDetail)
                        self?.movieSearchDetails.append(movieDetail)
                    }
                case .failure(let error):
                    print("Error fetching movie details for ID \(movieID): \(error)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("All movie details fetched successfully.")
        }
    }
}
