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
    @Published var movieSearchDetails: [Search.SearchDetailInfo] = []
    @Published var isLoading = false
    private let apiKey = "22392d65a7c9e67e5e3105aca487aec4"
    
    // MARK: - Name and Year Searching
    func searchMovies(query: String, category: String) {
        movieSearchDetails = []
        isLoading = true
        if category == "Name" {
            searchMoviesByName(query: query)
        } else if category == "Year" {
            searchMoviesByYear(year: query)
        }
    }
    
    private func searchMoviesByName(query: String) {
        guard !query.isEmpty else {
            movieSearchDetails = []
            isLoading = false
            return
        }
        
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&page=1"
        
        WebService().fetchData(from: urlString, resultType: SearchModel.self) { [weak self] result in
            switch result {
            case .success(let searchModel):
                let movieIDs = searchModel.results.map { $0.id }
                self?.fetchMovieDetails(for: movieIDs)
            case .failure(let error):
                print("Error fetching movies by name: \(error)")
                DispatchQueue.main.async {
                    self?.movieSearchDetails = []
                    self?.isLoading = false
                }
            }
        }
    }
    
    private func searchMoviesByYear(year: String) {
        guard !year.isEmpty else {
            movieSearchDetails = []
            isLoading = false
            return
        }
        
        let urlString = "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&primary_release_year=\(year)&sort_by=popularity.desc"
        
        WebService().fetchData(from: urlString, resultType: SearchModel.self) { [weak self] result in
            switch result {
            case .success(let searchModel):
                let movieIDs = searchModel.results.map { $0.id }
                self?.fetchMovieDetails(for: movieIDs)
            case .failure(let error):
                print("Error fetching movies by year: \(error)")
                DispatchQueue.main.async {
                    self?.movieSearchDetails = []
                    self?.isLoading = false
                }
            }
        }
    }

    private func fetchMovieDetails(for movieIDs: [Int]) {
        let dispatchGroup = DispatchGroup()
        var detailedMovies: [Search.SearchDetailInfo] = []
        
        for movieID in movieIDs {
            dispatchGroup.enter()
            let urlString = "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(apiKey)"
            
            WebService().fetchData(from: urlString, resultType: Search.SearchDetailInfo.self) { result in
                switch result {
                case .success(let movieDetail):
                    DispatchQueue.main.async {
                        detailedMovies.append(movieDetail)
                    }
                case .failure(let error):
                    print("Error fetching movie details for ID \(movieID): \(error)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.movieSearchDetails = detailedMovies
            self.isLoading = false
        }
    }
}
