//
//  MovieFavoriteView.swift
//  Movies
//
//  Created by Luka Gujejiani on 08.06.24.
//
import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct MovieFavoriteView: View {
    // MARK: Properties
    @StateObject private var viewModel = MovieFavouriteVM()
    @Environment(\.modelContext) private var modelContext
    @Query var favouriteMovies: [FavouriteMovie]
    @State private var navigationPath = NavigationPath()

    
    // MARK: - View
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                HStack{
                    Text("Favorite Movies")
                        .font(.title)
                        .bold()
                        .padding()
                    
                    Spacer()
                }
                
                Spacer()
                
                if favouriteMovies.isEmpty {
                    PlaceholderView(text: "No Favourites Yet", secondText: "All moves marked as favourite will be\nadded here")
                } else {
                    ScrollView {
                        ForEach(favouriteMovies, id: \.self) { movie in
                            Button {
                                navigationPath.append(movie.id)
                            } label: {
                                //Viyeneb shenaxul obieqts ro info gamovitano
                                MovieDetailsCell(posterPath: movie.posterPath ?? "", title: movie.title, voteAverage: movie.voteAverage, genre: movie.genres.first?.name ?? "No genre to display", releaseDate: movie.releaseDate, runtime: movie.runtime)

                            }
                        }
                    }
                    .navigationDestination(for: Int.self) { movieID in
                        MovieDetailsView(movieID: movieID)
                    }
                    .onAppear {
                        viewModel.movieDetails.removeAll()
                        let movies = favouriteMovies.map { Movie(id: $0.id, posterPath: $0.posterPath, title: $0.title) }
                        viewModel.fetchMovieDetails(for: movies)
                    }
                }
            }
        }
    }
}

#Preview {
    MovieFavoriteView()
}
