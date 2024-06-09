//
//  MovieDetailsViewModel.swift
//  Movies
//
//  Created by Luka Gujejiani on 07.06.24.
//

import Foundation
import SimpleNetworking

final class MovieDetailsViewModel: ObservableObject {
    // MARK: Properties
    @Published var movieInfo: DetailInfo?
    @Published var passedMovieID: Int
    
    // MARK: Initialization
    init(passedMovieID: Int) {
        self.passedMovieID = passedMovieID
        fetchDetails()
    }
    
    // MARK: Functions
    private func fetchDetails() {
        WebService().fetchData(from: "https://api.themoviedb.org/3/movie/\(passedMovieID)?api_key=22392d65a7c9e67e5e3105aca487aec4", resultType: DetailInfo.self) { [weak self] data in
            switch data {
            case .success(let movieDetails):
                DispatchQueue.main.async {
                    self?.movieInfo = movieDetails
                }
            case .failure(let error):
                print("Error fetching page info: \(error)")
            }
        }
    }
}
