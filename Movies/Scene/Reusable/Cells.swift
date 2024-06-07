//
//  MovieRow.swift
//  Movies
//
//  Created by Luka Gujejiani on 05.06.24.
//

import SwiftUI

struct MovieRow: View {
    // MARK: Properties
    let movie: Movie
    let height: CGFloat
    
    // MARK: - View
    var body: some View {
        VStack {
            if let posterPath = movie.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") {
                CacheAsyncImage(url: url) { AsyncImagePhase in
                    switch AsyncImagePhase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                            .frame(width: 110, height: 165)
                    case .empty:
                        ProgressView()
                            .frame(width: 110, height: 165)
                    case .failure(let error):
                        ErrorView(error: error)
                            .frame(width: 110, height: 165)
                    @unknown default:
                        Image(systemName: "questionmark")
                            .frame(width: 110, height: 165)
                    }
                }
                .padding(.top, 10)
            }
            Spacer()
            
            Text(movie.title)
                .font(.custom("Poppins-Regular", size: 12))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .lineLimit(3)
                .minimumScaleFactor(0.5)
                .layoutPriority(1)
                .foregroundStyle(Color(UIColor.label))
            
            Spacer()
        }
        .frame(height: height)
        .padding(.horizontal, 10)
    }
}

#Preview {
    MovieListView()
}

// MARK: - Movie Cell
struct MovieCell: View {
    let movie: Search.SearchDetailInfo
    
    var body: some View {
        HStack {
            if let posterPath = movie.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") {
                CacheAsyncImage(url: url) { AsyncImagePhase in
                    switch AsyncImagePhase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 95, height: 130)
                            .cornerRadius(10)
                    case .empty:
                        ProgressView()
                            .frame(width: 95, height: 130)
                    case .failure:
                        Image(systemName: "questionmark")
                            .frame(width: 95, height: 130)
                    @unknown default:
                        Image(systemName: "questionmark")
                            .frame(width: 95, height: 130)
                    }
                }
            }
            
            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.custom("Poppins-Regular", size: 16))
                
                HStack {
                    Image("Star")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", movie.voteAverage))
                        .foregroundColor(Color(hex: "#FF8700"))
                        .font(.custom("Montserrat-SemiBold", size: 12))
                }
                
                HStack {
                    Image("Ticket")
                    Text(movie.genres.first?.name ?? "Unknown")
                        .font(.custom("Poppins-Regular", size: 12))
                }
                
                HStack {
                    Image("Calendar")
                    Text(movie.releaseDate.components(separatedBy: "-").first ?? "Unknown")
                        .font(.custom("Poppins-Regular", size: 12))
                }
                
                HStack {
                    Image("Clock")
                    Text("\(movie.runtime) minutes")
                        .font(.custom("Poppins-Regular", size: 12))
                }
            }
            .foregroundColor(Color(UIColor.label))
            .padding(.leading, 5)
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Person Cell
struct PersonCell: View {
    let person: PersonResult
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let profilePath = person.profilePath, let url = URL(string: "https://image.tmdb.org/t/p/w500/\(profilePath)") {
                    CacheAsyncImage(url: url) { AsyncImagePhase in
                        switch AsyncImagePhase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 95, height: 130)
                                .cornerRadius(10)
                        case .empty:
                            ProgressView()
                                .frame(width: 95, height: 130)
                        case .failure:
                            Image(systemName: "questionmark")
                                .frame(width: 95, height: 130)
                        @unknown default:
                            Image(systemName: "questionmark")
                                .frame(width: 95, height: 130)
                        }
                    }
                }
                
                VStack(alignment: .leading) {
                    Text(person.name)
                        .font(.custom("Poppins-Regular", size: 16))
                    
                    Text("Known for:")
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(.gray)
                    
                    ForEach(person.knownFor, id: \.id) { knownFor in
                        Text(knownFor.title ?? knownFor.originalTitle ?? "Unknown")
                            .font(.custom("Poppins-Regular", size: 12))
                            .foregroundColor(.gray)
                    }
                }
                .foregroundColor(Color(UIColor.label))
                .padding(.leading, 5)
                
                Spacer()
            }
            .padding()
        }
    }
}

