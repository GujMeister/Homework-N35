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
    @Published var personSearchResults: [PersonResult] = []
    @Published var isLoading = false
    private let apiKey = "22392d65a7c9e67e5e3105aca487aec4"
    
    // MARK: - Search function
    func searchMovies(query: String, category: String) {
        movieSearchDetails = []
        personSearchResults = []
        isLoading = true
        if category == "Name" {
            searchMoviesByName(query: query)
        } else if category == "Year" {
            searchMoviesByYear(year: query)
        } else if category == "Person" {
            searchPerson(query: query)
        }
    }
    
    // MARK: - Fetching functions
    private func searchMoviesByName(query: String) {
        guard !query.isEmpty else {
            movieSearchDetails = []
            isLoading = false
            return
        }
        
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&page=1"
        
        WebService().fetchData(from: urlString, resultType: MovieID.MovieResponse.self) { [weak self] result in
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
        
        WebService().fetchData(from: urlString, resultType: MovieID.MovieResponse.self) { [weak self] result in
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
    
    private func searchPerson(query: String) {
        guard !query.isEmpty else {
            personSearchResults = []
            isLoading = false
            return
        }
        
        let urlString = "https://api.themoviedb.org/3/search/person?api_key=\(apiKey)&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&page=1"
        
        WebService().fetchData(from: urlString, resultType: PersonSearchModel.self) { [weak self] result in
            switch result {
            case .success(let personSearchModel):
                DispatchQueue.main.async {
                    self?.personSearchResults = personSearchModel.results
                    self?.isLoading = false
                }
            case .failure(let error):
                print("Error fetching person search results: \(error)")
                DispatchQueue.main.async {
                    self?.personSearchResults = []
                    self?.isLoading = false
                }
            }
        }
    }
        
    // MARK: - Helper function
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


// ეს არის კოდი რომელსაც ყველა პერსონაჟი მოაქ. უბრალოდ იმდენი ხანი უნდა ლოუდინგი რო არ ღირს და გადავწყვიტე ყველა კატეგორიაზე პირველი გვერდები წამომეღო.
/*
 private func searchPerson(query: String) {
     guard !query.isEmpty else {
         personSearchResults = []
         isLoading = false
         return
     }
     
     let initialUrlString = "https://api.themoviedb.org/3/search/person?api_key=\(apiKey)&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&page=1"
     
     // Fetch the first page to get the total number of pages
     WebService().fetchData(from: initialUrlString, resultType: PersonSearchModel.self) { [weak self] result in
         switch result {
         case .success(let personSearchModel):
             DispatchQueue.main.async {
                 self?.personSearchResults = personSearchModel.results
                 
                 let totalPages = personSearchModel.totalPages
                 
                 // Fetch the remaining pages
                 guard totalPages > 1 else {
                     self?.isLoading = false
                     return
                 }
                 
                 self?.fetchRemainingPages(query: query, totalPages: totalPages)
             }
         case .failure(let error):
             print("Error fetching person search results: \(error)")
             DispatchQueue.main.async {
                 self?.personSearchResults = []
                 self?.isLoading = false
             }
         }
     }
 }

 private func fetchRemainingPages(query: String, totalPages: Int) {
     let dispatchGroup = DispatchGroup()
     
     for page in 2...totalPages {
         dispatchGroup.enter()
         let urlString = "https://api.themoviedb.org/3/search/person?api_key=\(apiKey)&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&page=\(page)"
         
         WebService().fetchData(from: urlString, resultType: PersonSearchModel.self) { [weak self] result in
             switch result {
             case .success(let personSearchModel):
                 DispatchQueue.main.async {
                     self?.personSearchResults.append(contentsOf: personSearchModel.results)
                 }
             case .failure(let error):
                 print("Error fetching person search results for page \(page): \(error)")
             }
             dispatchGroup.leave()
         }
     }
     
     dispatchGroup.notify(queue: .main) {
         self.isLoading = false
     }
 }
 */
