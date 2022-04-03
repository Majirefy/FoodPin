//
//  DiscoverView.swift
//  FoodPin
//
//  Created by Fangcheng Song on 2022/4/3.
//

import SwiftUI
import CloudKit

struct DiscoverView: View {
    @StateObject private var restaurantCloudStore: RestaurantCloudStore = RestaurantCloudStore()
    @State private var isShowingIndicator = false
    
    var body: some View {
        NavigationView {
            ZStack {
                List(restaurantCloudStore.restaurants, id: \.recordID) { restaurant in
                    HStack {
                        AsyncImage(url: getImageURL(restaurant: restaurant)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 50, height: 50)
                        .cornerRadius(10)
                        Text(restaurant.object(forKey: "name") as! String)
                    }
                }
                .navigationTitle("Discover")
                .onAppear(perform: {
                    isShowingIndicator = true
                })
                .task {
                    restaurantCloudStore.fetchRestaurantsWithOperational {
                        isShowingIndicator = false
                    }
                }
                .refreshable {
                    restaurantCloudStore.fetchRestaurantsWithOperational {
                        isShowingIndicator = false
                    }
                }
                
                if isShowingIndicator {
                    ProgressView()
                }
            }
        }
    }
    
    private func getImageURL(restaurant: CKRecord) -> URL? {
        guard let image = restaurant.object(forKey: "image"), let imageAsset = image as? CKAsset else { return nil }
        return imageAsset.fileURL
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
