//
//  MovieDetailsView.swift
//  Movies
//
//  Created by Luka Gujejiani on 07.06.24.
//

import SwiftUI
import SwiftData

struct MovieDetailsView: View {
    @State var movie: Movie
    @StateObject var viewModel: MovieDetailsViewModel
    
    @Environment(\.modelContext) var modelContext
    @Query var favouriteMovies: [FavouriteMovie]
    
    @State private var isFavorite: Bool = false
    
    // MARK: Init
    init(movie: Movie) {
        self.movie = movie
        _viewModel = StateObject(wrappedValue: MovieDetailsViewModel(passedMovie: movie))
    }
    
    // MARK: - View
    var body: some View {
        VStack {
            NavigationView(movie: movie)
            
            ScrollView {
                VStack {
                    VStack {
                        if let bigPosterPath = viewModel.movieInfo?.backdropPath, let url = URL(string: "https://image.tmdb.org/t/p/w500/\(bigPosterPath)") {
                            CacheAsyncImage(url: url) { AsyncImagePhase in
                                switch AsyncImagePhase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 200)
                                        .clipShape(
                                            .rect(
                                                topLeadingRadius: 0,
                                                bottomLeadingRadius: 20,
                                                bottomTrailingRadius: 20,
                                                topTrailingRadius: 0
                                            )
                                        )
                                        .clipped()
                                case .empty:
                                    ProgressView()
                                        .frame(height: 200)
                                case .failure:
                                    Image(systemName: "questionmark")
                                        .frame(height: 200)
                                @unknown default:
                                    Image(systemName: "questionmark")
                                        .frame(height: 200)
                                }
                            }
                        }
                        
                        // MARK: Rating and Star Image
                        HStack {
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(hex: "252836")).opacity(0.9)
                                    .frame(height: 30)
                                HStack(spacing: 5) {
                                    Image("Star")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                    Text(String(format: "%.1f", viewModel.movieInfo?.voteAverage ?? 0) )
                                        .foregroundColor(Color(hex: "FF8700"))
                                        .font(.custom("Montserrat-SemiBold", size: 16))
                                        .padding(.top, 2)
                                }
                            }
                            .frame(width: 65, height: 24)
                            .padding(.top, -50)
                            .padding(.trailing, 20)
                        }
                    }
                    
                    // MARK: Poster and Title
                    HStack(alignment: .top) {
                        if let posterPath = viewModel.movieInfo?.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") {
                            CacheAsyncImage(url: url) { AsyncImagePhase in
                                switch AsyncImagePhase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(10)
                                        .frame(width: 114, height: 144)
                                case .empty:
                                    ProgressView()
                                        .frame(width: 100, height: 150)
                                case .failure:
                                    Image(systemName: "questionmark")
                                        .frame(width: 100, height: 150)
                                @unknown default:
                                    Image(systemName: "questionmark")
                                        .frame(width: 100, height: 150)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Spacer()
                            
                            HStack {
                                Text(viewModel.movieInfo?.title ?? "")
                                    .font(.custom("Montserrat-SemiBold", size: 18))
                                    .padding(.bottom, 3)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(.leading, 25)
                    .padding(.top, -90)
                    
                    // MARK: Info View
                    HStack {
                        HStack(spacing: 4) {
                            Image("Calendar")
                            Text(viewModel.movieInfo?.releaseDate.components(separatedBy: "-").first ?? "2010")
                                .foregroundStyle(Color(hex: "#92929D"))
                        }
                        
                        RoundedRectangle(cornerRadius: 0)
                            .frame(width: 1, height: 15)
                            .foregroundStyle(Color(hex: "#92929D"))
                        
                        HStack(spacing: 4) {
                            Image("Clock")
                            Text(String(viewModel.movieInfo?.runtime ?? 10) + " Minutes")
                                .foregroundStyle(Color(hex: "#92929D"))
                        }
                        
                        RoundedRectangle(cornerRadius: 0)
                            .frame(width: 1, height: 15)
                            .foregroundStyle(Color(hex: "#92929D"))
                        
                        HStack(spacing: 4) {
                            Image("Ticket")
                            Text(viewModel.movieInfo?.genres.first?.name ?? "Unknown")
                                .foregroundStyle(Color(hex: "#92929D"))
                        }
                    }
                    .font(.custom("Montserrat-Medium", size: 13))
                    .padding(.top)
                    
                    // MARK: About Movie VStack
                    VStack(alignment: .leading) {
                        HStack {
                            Text("About Movie")
                                .font(.custom("Poppins-Regular", size: 18))
                                .padding(.vertical, 4)
                            
                            Spacer()
                            
                            Button {
                                toggleFavorite()
                            } label: {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .resizable()
                                    .frame(width: 22, height: 20)
                                    .foregroundStyle(isFavorite ? .red : .black)
                            }
                        }
                        .padding(.horizontal, 10)
                        
                        RoundedRectangle(cornerRadius: 0)
                            .frame(height: 4)
                            .foregroundStyle(Color(hex: "#C6C6C6"))
                        
                        Text(viewModel.movieInfo?.overview ?? "")
                            .font(.custom("Poppins-Regular", size: 14))
                            .padding(.top, 15)
                    }
                    .padding(.top, 30)
                    .padding(.horizontal, 30)
                }
            }
        }
        .onAppear {
            checkIfFavorite()
        }
    }
    
    func toggleFavorite() {
        if isFavorite {
            if let favouriteMovie = favouriteMovies.first(where: { $0.movieID == movie.id }) {
                modelContext.delete(favouriteMovie)
            }
        } else {
            let newFavourite = FavouriteMovie(movie: movie)
            modelContext.insert(newFavourite)
        }
        
        do {
            try modelContext.save()
            checkIfFavorite()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    func checkIfFavorite() {
        isFavorite = favouriteMovies.contains(where: { $0.movieID == movie.id })
    }
}

// MARK: - Navigation Bar Back Button Visual
struct NavigationView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var movie: Movie
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    self.mode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                    Text("Movies")
                        .padding(.leading, -5)
                }
                
                Spacer()
                
                Text(movie.title)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "arrow.left")
                        .opacity(0)
                    Text("Movies")
                        .opacity(0)
                        .padding(.leading, -5)
                }
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    MovieDetailsView(movie: Movie(id: 62012, posterPath: "asdasdasd", title: "asdasdasd"))
}
