//
//  MovieDetailsView.swift
//  Movies
//
//  Created by Luka Gujejiani on 07.06.24.
//

// TODO: Fonts, Different font for rating, Font sizes

import SwiftUI

struct MovieDetailsView: View {
    
    @State var movie: Movie
    @StateObject var viewModel: MovieDetailsViewModel
    
    // MARK: Init
    init(movie: Movie) {
        self.movie = movie
        _viewModel = StateObject(wrappedValue: MovieDetailsViewModel(passedMovie: movie))
    }
    
    // MARK: - View
    var body: some View {
        MenuView(movie: movie)
        
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
                    
                    HStack {
                        Spacer()
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(hex: "252836")).opacity(0.7)
                            HStack {
                                Image("Star")
                                Text(String(format: "%.1f", viewModel.movieInfo?.voteAverage ?? 0) )
                                    .foregroundColor(Color(hex: "FF8700"))
                            }
                        }
                        .frame(width: 65, height: 24)
                        .padding(.top, -40)
                        .padding(.trailing, 20)
                    }
                }
                
                HStack(alignment: .top) {
                    if let posterPath = viewModel.movieInfo?.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") {
                        CacheAsyncImage(url: url) { AsyncImagePhase in
                            switch AsyncImagePhase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(10)
                                    .frame(width: 100, height: 150)
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
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Spacer()
                        
                        Text(viewModel.movieInfo?.title ?? "")
                            .padding(.bottom, 20)
                            .frame(minWidth: 200)
                            .font(.title)
                            .bold()
                    }
                }
                .padding(.top, -70)
                
                
                
                // MARK: - Info View
                HStack {
                    HStack {
                        Image("Calendar")
                        Text(viewModel.movieInfo?.releaseDate.components(separatedBy: "-").first ?? "2010")
                            .foregroundStyle(Color(hex: "#92929D"))
                    }
                    
                    RoundedRectangle(cornerRadius: 0)
                        .frame(width: 1, height: 15)
                        .foregroundStyle(Color(hex: "#92929D"))
                    
                    HStack {
                        Image("Clock")
                        Text(String(viewModel.movieInfo?.runtime ?? 10))
                            .foregroundStyle(Color(hex: "#92929D"))
                    }
                    
                    RoundedRectangle(cornerRadius: 0)
                        .frame(width: 1, height: 15)
                        .foregroundStyle(Color(hex: "#92929D"))
                    
                    HStack {
                        Image("Ticket")
                        Text(viewModel.movieInfo?.genres.first?.name ?? "Unknown")
                            .foregroundStyle(Color(hex: "#92929D"))
                    }
                }
                .padding(.top)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("About Movie")
                        .font(.headline)
                        .padding(.vertical, 4)
                    
                    RoundedRectangle(cornerRadius: 0)
                        .frame(height: 4)
                        .foregroundStyle(Color(hex: "#3A3F47"))
                    
                    Text(movie.overview)
                        .font(.body)
                        .padding(.top, 15)
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    MovieDetailsView(movie: Movie(backdropPath: "/fqv8v6AycXKsivp1T5yKtLbGXce.jpg", genreIds: [1], id: 653346, overview: "Several generations in the future following Caesar's reign, apes are now the dominant species and live harmoniously while humans have been reduced to living in the shadows. As a new tyrannical ape leader builds his empire, one young ape undertakes a harrowing journey that will cause him to question all that he has known about the past and to make choices that will define a future for apes and humans alike.", posterPath: "/gKkl37BQuKTanygYQG1pyYgLVgf.jpg", releaseDate: "2024-05-08", title: "Kingdom of the Planet of the Apes", voteAverage: 6.925, voteCount: 12))
}


// MARK: - Navigation Bar Back Button Visual

struct MenuView : View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var movie: Movie
    
    var body : some View {
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
