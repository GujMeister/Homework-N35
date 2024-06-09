//
//  MovieFavoriteView.swift
//  Movies
//
//  Created by Luka Gujejiani on 08.06.24.
//

import SwiftUI
import SwiftData

struct MovieFavoriteView: View {
    @StateObject private var viewModel = MovieFavouriteVM()
    @Environment(\.modelContext) private var modelContext
    @Query var favouriteMovies: [FavouriteMovie] // ამაში არის ბევრი Movie (ეს გინდა რო დეტალები ანახო
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Favorite Movies")
                    .font(.title)
                    .padding()
                
                ForEach(viewModel.movieDetails) { movie in
                    FavouritesMovieCell(movie: movie)
                }
            }
            
            //TODO: viewModel.movieDetails.removeAll() ხაზის გარეშე ადუპლიკატებს დალაიქებულ ფილმებს!
            .onAppear {
                viewModel.movieDetails.removeAll()
                let movies = favouriteMovies.map { Movie(id: $0.movieID, posterPath: $0.posterPath, title: $0.title) }
                viewModel.fetchMovieDetails(for: movies)
            }
        }
    }
}

#Preview {
    MovieFavoriteView()
}
