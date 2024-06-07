//
//  MainScene.swift
//  Movies
//
//  Created by Luka Gujejiani on 05.06.24.
//

import SwiftUI

struct MainScene: View {
    // MARK: Properties
    @State private var selectedTab = 0
    
    // MARK: - View
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedTab) {
                MovieListView()
                    .tag(0)
                MovieSearchView()
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onChange(of: selectedTab) { oldValue, newValue in
                if oldValue == 1 && newValue != 1 {
                    NotificationCenter.default.post(name: .resetSearch, object: nil)
                }
            }
            
            CustomTabBar(selectedTab: $selectedTab, tabBarItems: [
                TabBarItem(title: "Movies", imageName: "movieclapper.fill"),
                TabBarItem(title: "Search", imageName: "magnifyingglass"),
            ])
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

// MARK: - Preview
struct MainScene_Previews: PreviewProvider {
    static var previews: some View {
        MainScene()
    }
}

// MARK: - Tab Bar
struct CustomTabBar: View {
    @Binding var selectedTab: Int
    let tabBarItems: [TabBarItem]
    
    var body: some View {
        HStack {
            ForEach(0..<2) { index in
                VStack {
                    Rectangle()
                        .frame(height: 2)
                        .frame(width: 150)
                        .foregroundColor(selectedTab == index ? Color(hex: "#f0ca6b") : .clear)
                    Image(systemName: tabBarItems[index].imageName)
                        .font(.system(size: 24))
                        .foregroundColor(selectedTab == index ? Color(hex: "#decc9e") : .gray)
                        .padding(.top, 2)
                    Text(tabBarItems[index].title)
                        .font(.system(size: 12))
                        .foregroundColor(selectedTab == index ? Color(hex: "#decc9e") : .gray)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .onTapGesture {
                    withAnimation {
                        selectedTab = index
                    }
                }
            }
        }
    }
}

struct TabBarItem {
    let title: String
    let imageName: String
}
