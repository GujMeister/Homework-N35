//
//  MovieSearchView.swift
//  Movies
//
//  Created by Luka Gujejiani on 05.06.24.
//

import SwiftUI

struct MovieSearchView: View {
    // MARK: Properties
    @StateObject var viewModel = MovieSearchViewModel()
    @State private var searchText = ""
    @State private var selectedCategory = "Name"
    @State private var hasSearched = false
    let categories = ["Name", "Year"]
    
    // MARK: - View
    var body: some View {
        VStack {
            HStack {
                Text("Search")
                    .bold()
                    .font(.title)
                    .padding(.horizontal)
                Spacer()
            }
            
            HStack {
                SearchBar(text: $searchText, onSearchButtonClicked: {
                    hasSearched = true
                    viewModel.searchMovies(query: searchText, category: selectedCategory)
                })
                
                // MARK: Dropdown menu
                Menu {
                    ForEach(categories, id: \.self) { category in
                        Button(category, action: {
                            selectedCategory = category
                            hasSearched = false
                            viewModel.movieSearchDetails = []
                        })
                    }
                } label: {
                    Image("Elipse")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color(UIColor.label))
                        .frame(width: 25, height: 25)
                        .padding(.trailing, 15)
                }
            }
            
            // MARK: Progess View and Text before search
            if viewModel.isLoading {
                Spacer()
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .padding()
                
                Spacer()
            } else if !hasSearched {
                PlaceholderView(text: "Use The Magic Search!", secondText: "I will do my best to search everything\n relevant, I promise!")
            } else if viewModel.movieSearchDetails.isEmpty {
                PlaceholderView(text: "Oh No Isn’t This So Embarrassing?", secondText: "I cannot find any movie with this name.")
            } else {
                List(viewModel.movieSearchDetails, id: \.title) { movie in
                    MovieCell(movie: movie)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color(UIColor.systemBackground))
                }
                .listStyle(PlainListStyle())
                .padding([.horizontal], -13)
                .scrollContentBackground(.hidden)
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: .resetSearch, object: nil, queue: .main) { _ in
                searchText = ""
                viewModel.movieSearchDetails = []
                hasSearched = false
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: .resetSearch, object: nil)
        }
    }
}

// MARK: - Search Bar
struct SearchBar: View {
    @Binding var text: String
    var onSearchButtonClicked: () -> Void
    
    var body: some View {
        HStack {
            TextField("try Spider-man :)", text: $text)
                .font(.custom("Poppins-Regular", size: 14))
                .frame(height: 35)
                .padding(7)
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .padding(.horizontal, 10)
                .overlay(
                    HStack {
                        Spacer()
                        Button(action: onSearchButtonClicked) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(UIColor.label))
                                .padding(.trailing, 20)
                        }
                    }
                )
        }
    }
}

// MARK: - Placeholder View
struct PlaceholderView: View {
    let text: String
    let secondText: String
    
    var body: some View {
        VStack {
            Spacer()
            Text(text)
                .multilineTextAlignment(.center)
                .font(.custom("Montserrat-SemiBold", size: 18))
                .foregroundColor(Color(UIColor.secondaryLabel))
            
            Text(secondText)
                .multilineTextAlignment(.center)
                .font(.custom("Montserrat-Medium", size: 14))
                .foregroundColor(Color(hex: "92929D"))
                .padding(.top, 20)
            
            Spacer()
        }
    }
}

// MARK: - Notification
extension Notification.Name {
    static let resetSearch = Notification.Name("resetSearch")
}

// MARK: - Preview
#Preview {
    MovieSearchView()
}

// MARK: - Cell
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
