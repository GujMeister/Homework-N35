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
                }
            }
        }
    }
}

#Preview {
    MovieFavoriteView()
}
