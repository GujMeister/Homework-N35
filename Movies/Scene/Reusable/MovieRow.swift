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
    @State private var isVisible = false
    //    let width: CGFloat
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
                            .frame(width: 100, height: 145) // Adjust the width and height as needed
                    case .empty:
                        ProgressView()
                            .frame(width: 100, height: 145) // Adjust the width and height as needed
                    case .failure(let error):
                        ErrorView(error: error)
                            .frame(width: 100, height: 145) // Adjust the width and height as needed
                    @unknown default:
                        Image(systemName: "questionmark")
                            .frame(width: 100, height: 145) // Adjust the width and height as needed
                    }
                }
                .padding(.top, 10)
            }
            Spacer()
            
            Text(movie.title)
                .font(.custom("FiraGO-Regular", size: 12))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .lineLimit(2) // Allows the title to span up to 2 lines
                .minimumScaleFactor(0.5) // Adjusts the font size if the text doesn't fit
                .layoutPriority(1)
                .foregroundStyle(Color(UIColor.label))
            
            Spacer()
        }
        .frame(height: height)
        .padding(.horizontal)
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 20)
        .onAppear {
            withAnimation(.easeIn(duration: 0.5)) {
                isVisible = true
            }
        }
    }
}

#Preview {
    MovieListView()
}
