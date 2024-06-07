//
//  MovieListView.swift
//  Movies
//
//  Created by Luka Gujejiani on 04.06.24.
//

import SwiftUI

struct MovieListView: View {
    // MARK: Properties
    @StateObject var viewModel = MovieListViewModel()
    @State private var path = NavigationPath()
    
    let columns = [
        GridItem(.flexible(minimum: 100, maximum: 200)),
        GridItem(.flexible(minimum: 100, maximum: 200)),
        GridItem(.flexible(minimum: 100, maximum: 200))
    ]
    
    // MARK: - View
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                HStack {
                    Text("Movies")
                        .bold()
                        .font(.title)
                        .padding(.horizontal)
                    Spacer()
                }
                
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.allMovies) { movie in
                            NavigationLink(value: movie) {
                                MovieRow(movie: movie, height: 200)
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailsView(movie: movie)
            }
        }
    }
}
    
    
    // MARK: - Preview
    #Preview {
        MovieListView()
    }
