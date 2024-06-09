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
    @Query var movies: [FavouriteMovie]

    var body: some View {
        VStack {
            Text("Favorite Movies")
                .font(.title)
                .padding()
            
            List(viewModel.movieDetails) { movie in
                HStack {
                    if let posterPath = movie.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") {
                        CacheAsyncImage(url: url) { AsyncImagePhase in
                            switch AsyncImagePhase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 75)
                                    .cornerRadius(8)
                            case .empty:
                                ProgressView()
                                    .frame(width: 50, height: 75)
                            case .failure:
                                Image(systemName: "questionmark")
                                    .frame(width: 50, height: 75)
                            @unknown default:
                                Image(systemName: "questionmark")
                                    .frame(width: 50, height: 75)
                            }
                        }
                    }
                    VStack(alignment: .leading) {
                        Text(movie.title)
                            .font(.headline)
                        Text(movie.overview)
                            .font(.subheadline)
                            .lineLimit(3)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchMovieDetails(for: movies)
        }
    }
}

#Preview {
    MovieFavoriteView()
}
