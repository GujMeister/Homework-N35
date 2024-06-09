//
//  Cells.swift
//  Movies
//
//  Created by Luka Gujejiani on 05.06.24.
//

import SwiftUI

// MARK: - Movie Row for MovieListView
struct MovieRow: View {
    let movie: Movie
    let height: CGFloat
    
    var body: some View {
        VStack {
            if let posterPath = movie.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") {
                poster(url: url, width: 110, height: 165)
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

// MARK: - Movie Details Cell
struct MovieDetailsCell: View {
    let posterPath: String
    let title: String
    let voteAverage: Double
    let genre: String
    let releaseDate: String
    let runtime: Int
    
    var body: some View {
        HStack {
            if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") {
                poster(url: url, width: 95, height: 130)
            }
            
            VStack(alignment: .leading) {
                Text(title)
                    .lineLimit(1)
                    .minimumScaleFactor(1)
                    .font(.custom("Poppins-Regular", size: 16))
                
                HStack {
                    Image("Star")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", voteAverage))
                        .foregroundColor(Color(hex: "#FF8700"))
                        .font(.custom("Montserrat-SemiBold", size: 12))
                }
                
                HStack {
                    Image("Ticket")
                    Text(genre)
                        .font(.custom("Poppins-Regular", size: 12))
                }
                
                HStack {
                    Image("Calendar")
                    Text(releaseDate.components(separatedBy: "-").first ?? "Unknown")
                        .font(.custom("Poppins-Regular", size: 12))
                }
                
                HStack {
                    Image("Clock")
                    Text("\(runtime) minutes")
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
                    poster(url: url, width: 95, height: 130)
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


// MARK: - Reusable Poster
struct poster: View {
    let url: URL
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        CacheAsyncImage(url: url) { AsyncImagePhase in
            switch AsyncImagePhase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
                    .cornerRadius(10)
            case .empty:
                ProgressView()
                    .frame(width: width, height: height)
            case .failure:
                Image(systemName: "questionmark")
                    .frame(width: width, height: height)
            @unknown default:
                Image(systemName: "questionmark")
                    .frame(width: width, height: height)
            }
        }
    }
}
