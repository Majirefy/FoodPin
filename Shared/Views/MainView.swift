//
//  MainView.swift
//  FoodPin
//
//  Created by Fangcheng Song on 2022/4/2.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTabIndex = 0
    
    var body: some View {
        TabView(selection: $selectedTabIndex) {
            RestaurantListView()
                .tabItem {
                    Label("Favorites", systemImage: "tag.fill")
                }
                .tag(0)
            DiscoverView()
                .tabItem {
                    Label("Dicover", systemImage: "wand.and.rays")
                }
                .tag(1)
            AboutView()
                .tabItem {
                    Label("About", systemImage: "square.stack")
                }
                .tag(2)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
