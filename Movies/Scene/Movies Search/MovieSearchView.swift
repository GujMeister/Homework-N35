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
    let categories = ["Name", "Year", "Person"]
    
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
                }, placeholder: placeholderText(for: selectedCategory))
                
                // MARK: Dropdown menu
                Menu {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                            hasSearched = false
                            viewModel.movieSearchDetails = []
                            viewModel.personSearchResults = []
                            searchText = ""
                        }) {
                            if category == selectedCategory {
                                Label(category, systemImage: "checkmark")
                            } else {
                                Text(category)
                            }
                        }
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
            
            // MARK: Progress View and Text before search
            if viewModel.isLoading {
                Spacer()
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .padding()
                
                Spacer()
            } else if !hasSearched {
                PlaceholderView(text: "Use The Magic Search!", secondText: "I will do my best to search everything\n relevant, I promise!")
            } else if selectedCategory == "Person" && viewModel.personSearchResults.isEmpty {
                PlaceholderView(text: "Oh No Isn’t This So Embarrassing?", secondText: "I cannot find any person with this name.")
            } else if viewModel.movieSearchDetails.isEmpty && viewModel.personSearchResults.isEmpty {
                PlaceholderView(text: "Oh No Isn’t This So Embarrassing?", secondText: "I cannot find anything with this name.")
            } else {
                List {
                    if selectedCategory == "Person" {
                        ForEach(viewModel.personSearchResults, id: \.id) { person in
                            PersonCell(person: person)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color(UIColor.systemBackground))
                        }
                    } else {
                        ForEach(viewModel.movieSearchDetails, id: \.title) { movie in
                            MovieCell(movie: movie)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color(UIColor.systemBackground))
                        }
                    }
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
                viewModel.personSearchResults = []
                hasSearched = false
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: .resetSearch, object: nil)
        }
    }
    
    private func placeholderText(for category: String) -> String {
        switch category {
        case "Name":
            return "try spider-man :)"
        case "Year":
            return "try 2012 :)"
        case "Person":
            return "try Jason :)"
        default:
            return "Search..."
        }
    }
}

// MARK: - Search Bar
struct SearchBar: View {
    @Binding var text: String
    var onSearchButtonClicked: () -> Void
    var placeholder: String
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .font(.custom("Poppins-Regular", size: 14))
                .frame(height: 35)
                .padding(7)
                .padding(.horizontal, 10)
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

