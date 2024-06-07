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
                TabBarItem(title: "Home", imageName: "Home"),
                TabBarItem(title: "Search", imageName: "Search"),
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
                    Image(tabBarItems[index].imageName)
                        .renderingMode(.template)
                        .font(.system(size: 24))
                        .foregroundColor(selectedTab == index ? Color(hex: "#0296E5") : Color(hex: "67686D"))
                        .padding(.top, 2)
                    Text(tabBarItems[index].title)
                        .font(.custom("Roboto-Medium", size: 12))
                        .foregroundColor(selectedTab == index ? Color(hex: "#0296E5") : Color(hex: "67686D"))
                    Spacer()
                }
                .padding(.top)
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
