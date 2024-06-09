//
//  MovieDetailsView.swift
//  Movies
//
//  Created by Luka Gujejiani on 07.06.24.
//

import SwiftUI
import SwiftData

struct MovieDetailsView: View {
    // MARK: Properties
    @State var movieID: Int
    @State private var isFavorite: Bool = false
    @StateObject var viewModel: MovieDetailsViewModel
    @Environment(\.modelContext) var modelContext
    @Query var favouriteMovies: [FavouriteMovie]

    // MARK: init
    init(movieID: Int) {
        self.movieID = movieID
        _viewModel = StateObject(wrappedValue: MovieDetailsViewModel(passedMovieID: movieID))
    }
    
    // MARK: - View
    var body: some View {
        VStack {
            NavigationView(viewModel: viewModel)
            
            ScrollView {
                VStack {
                    VStack {
                        if let bigPosterPath = viewModel.movieInfo?.backdropPath, let url = URL(string: "https://image.tmdb.org/t/p/w500/\(bigPosterPath)") {
                            coverPoster(url: url, height: 200)
                        }
                        
                        ratingAndStarView(voteAverage: viewModel.movieInfo?.voteAverage ?? 0)
                    }
                    
                    PosterAndTitleView(
                        url: ((URL(string: "https://image.tmdb.org/t/p/w500/\(viewModel.movieInfo?.posterPath ?? "")") ?? URL(string: "https://image.tmdb.org/t/p/w500/default.jpg"))!),
                        title: viewModel.movieInfo?.title ?? "No title found",
                        width: 144,
                        height: 144)
                    
                    InfoView(releaseDate: viewModel.movieInfo?.releaseDate.components(separatedBy: "-").first ?? "Unknown Release Date",
                             runtime: viewModel.movieInfo?.runtime ?? 0,
                             genre: viewModel.movieInfo?.genres.first?.name ?? "Unknown Genre")
                    
                    AboutMovieView(
                        overview: viewModel.movieInfo?.overview ?? "",
                        isFavorite: isFavorite,
                        toggleFavorite: toggleFavorite
                    )
                }
                
            }
        }
        .onAppear {
            checkIfFavorite()
        }
    }
    
    // MARK: - Helper functions
    func toggleFavorite() {
        if isFavorite {
            if let favouriteMovie = favouriteMovies.first(where: { $0.id == movieID }) {
                modelContext.delete(favouriteMovie)
            }
        } else {
            if let movieInfo = viewModel.movieInfo {
                let newFavourite = FavouriteMovie(movie: movieInfo)
                modelContext.insert(newFavourite)
            }
        }
        
        do {
            try modelContext.save()
            checkIfFavorite()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    func checkIfFavorite() {
        isFavorite = favouriteMovies.contains(where: { $0.id == movieID })
    }
}

#Preview {
    MovieDetailsView(movieID: 620022)
}

// MARK: - Custom Views
// MARK: Navigation Bar Back Button Visual
struct NavigationView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @StateObject var viewModel: MovieDetailsViewModel
    
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
                
                Text(viewModel.movieInfo?.title ?? "OOPS")
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

// MARK: Cover poster
struct coverPoster: View {
    let url: URL
    let height: CGFloat
    
    var body: some View {
        CacheAsyncImage(url: url) { AsyncImagePhase in
            switch AsyncImagePhase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: height)
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
                    .frame(height: height)
            case .failure:
                Image(systemName: "questionmark")
                    .frame(height: height)
            @unknown default:
                Image(systemName: "questionmark")
                    .frame(height: height)
            }
        }
    }
}

// MARK: Rating and Star View
struct ratingAndStarView: View {
    let voteAverage: Double
    
    var body: some View {
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
                    Text(String(format: "%.1f", voteAverage) )
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
}

// MARK: - Poster And Title View
struct PosterAndTitleView: View {
    let url: URL
    let title: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        HStack(alignment: .top) {
            poster(url: url, width: 114, height: 144)
            
            VStack(alignment: .leading) {
                Spacer()
                
                HStack {
                    Text(title)
                        .font(.custom("Montserrat-SemiBold", size: 18))
                        .padding(.bottom, 3)
                    
                    Spacer()
                }
            }
        }
        .padding(.leading, 25)
        .padding(.top, -90)
    }
}

// MARK: - Info View
struct InfoView: View {
    var releaseDate: String
    var runtime: Int
    var genre: String
    
    var body: some View {
        HStack {
            HStack(spacing: 4) {
                Image("Calendar")
                Text(releaseDate)
                    .foregroundStyle(Color(hex: "#92929D"))
            }
            
            RoundedRectangle(cornerRadius: 0)
                .frame(width: 1, height: 15)
                .foregroundStyle(Color(hex: "#92929D"))
            
            HStack(spacing: 4) {
                Image("Clock")
                Text(String(runtime) + " Minutes")
                    .foregroundStyle(Color(hex: "#92929D"))
            }
            
            RoundedRectangle(cornerRadius: 0)
                .frame(width: 1, height: 15)
                .foregroundStyle(Color(hex: "#92929D"))
            
            HStack(spacing: 4) {
                Image("Ticket")
                Text(genre)
                    .foregroundStyle(Color(hex: "#92929D"))
            }
        }
        .font(.custom("Montserrat-Medium", size: 13))
        .padding(.top)
    }
}

// MARK: - About Movie View
struct AboutMovieView: View {
    let overview: String
    let isFavorite: Bool
    let toggleFavorite: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("About Movie")
                    .font(.custom("Poppins-Regular", size: 18))
                    .padding(.vertical, 4)
                
                Spacer()
                
                Button(action: toggleFavorite) {
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
            
            Text(overview)
                .font(.custom("Poppins-Regular", size: 14))
                .padding(.top, 15)
        }
        .padding(.top, 30)
        .padding(.horizontal, 30)
    }
}
