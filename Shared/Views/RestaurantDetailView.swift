//
//  RestaurantDetailView.swift
//  FoodPin
//
//  Created by Fangcheng Song on 2022/3/16.
//

import SwiftUI

struct RestaurantDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @ObservedObject var restaurant: Restaurant
    
    @State private var isShowingReview = false
    
    var body: some View {
        ScrollView {
            Image(uiImage: UIImage(data: restaurant.image!)!)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 400)
                .overlay {
                    Image(systemName: restaurant.isFavorite ? "heart.fill" : "heart")
                        .font(.title)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topTrailing)
                        .padding()
                        .padding(.top, 40)
                        .foregroundColor(.yellow)
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(restaurant.name!)
                                .font(.largeTitle)
                                .bold()
                            Text(restaurant.type!)
                                .font(.headline)
                                .bold()
                                .padding(.all, 6)
                                .background(.black)
                        }
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .bottomLeading)
                        .padding()
                        if let rating = restaurant.rating, !isShowingReview {
                            Image(systemName: rating.icon)
                                .font(.largeTitle.bold())
                                .symbolVariant(.fill)
                                .foregroundColor(.white)
                                .transition(.scale)
                                .padding()
                        }
                    }
                    .animation(.spring(response: 0.2, dampingFraction: 0.3, blendDuration: 0.3), value: restaurant.rating)
                }
            Text(restaurant.summary!)
                .padding(.horizontal)
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Address")
                        .font(.headline)
                    Text(restaurant.address ?? "")
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                Divider()
                VStack(alignment: .leading) {
                    Text("Phone")
                        .font(.headline)
                    Text(restaurant.phone ?? "")
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            NavigationLink {
                MapView(address: restaurant.address ?? "")
                    .edgesIgnoringSafeArea(.all)
            } label: {
                MapView(address: restaurant.address ?? "")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 200)
                    .cornerRadius(20)
                    .padding()
            }
            Button {
                withAnimation {
                    isShowingReview.toggle()
                }
            } label: {
                Text("Rate it")
                    .font(.headline)
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            .padding(.horizontal)
            .padding(.bottom)
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Label("\(restaurant.name!)", systemImage: "chevron.left")
                }
                .tint(.white)
            }
        }
        .overlay {
            isShowingReview ? ZStack {
                ReviewView(restaurant: restaurant, isDisplayed: $isShowingReview)
                    .navigationBarHidden(true)
            } : nil
        }
        .onChange(of: restaurant) { _  in
            if self.managedObjectContext.hasChanges {
                try? self.managedObjectContext.save()
            }
        }
    }
}

struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RestaurantDetailView(restaurant: (PersistenceController.testData?.first)!)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .tint(.white)
        }
    }
}
