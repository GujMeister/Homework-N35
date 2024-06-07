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
