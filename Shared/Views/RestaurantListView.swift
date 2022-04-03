//
//  RestaurantListView.swift
//  Shared
//
//  Created by Fangcheng Song on 2022/3/14.
//

import SwiftUI

struct RestaurantListView: View {
    @AppStorage("hasViewedWalkthrough") private var hasViewedWalkThrough: Bool = false
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @FetchRequest(entity: Restaurant.entity(), sortDescriptors: [])
    var restaurants: FetchedResults<Restaurant>
    
    @State private var isShowWalkthrough = false
    @State private var searchText = ""
    @State private var isNewRestaurantPresented = false
    
    var body: some View {
        NavigationView {
            List {
                if restaurants.count == 0 {
                    Image("EmptyList")
                        .resizable()
                        .scaledToFit()
                } else {
                    ForEach(restaurants.indices, id: \.self) { index in
                        NavigationLink(destination: RestaurantDetailView(restaurant: restaurants[index]), label: {
                            BasicTextImageRow(restaurant: restaurants[index])
                        })
                    }
                    .onDelete(perform: delete)
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .navigationTitle("FoodPin")
            .toolbar {
                Button {
                    isNewRestaurantPresented.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search Restaurants") {
            Text("Thai").searchCompletion("Thai")
            Text("Cafe").searchCompletion("Cafe")
        }
        .onChange(of: searchText, perform: { newValue in
            let predicate = searchText.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "name CONTAINS[c] %@", newValue)
            restaurants.nsPredicate = predicate
        })
        .sheet(isPresented: $isNewRestaurantPresented) {
            NewRestaurantView()
        }
        .sheet(isPresented: $isShowWalkthrough) {
            TutorialView()
        }
        .onAppear {
            isShowWalkthrough = !hasViewedWalkThrough
        }
    }
    
    private func delete(indexSet: IndexSet) {
        for index in indexSet {
            let itemToDelete = restaurants[index]
            managedObjectContext.delete(itemToDelete)
        }
        DispatchQueue.main.async {
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
}

struct RestaurantListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RestaurantListView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .previewDisplayName("Light Mode")
                .preferredColorScheme(.light)
            RestaurantListView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .previewDisplayName("Dark Mode")
                .preferredColorScheme(.dark)
        }
    }
}

struct BasicTextImageRow: View {
    @ObservedObject var restaurant: Restaurant
    
    @State private var isShowingDialog = false
    @State private var isShowingError = false
    
    var body: some View {
        HStack(alignment: .top) {
            if let imageData = restaurant.image {
                Image(uiImage: UIImage(data: imageData) ?? UIImage())
                    .resizable()
                    .frame(width: 128, height: 128)
                    .cornerRadius(20)
            }
            VStack(alignment: .leading) {
                Text(restaurant.name ?? "")
                    .font(.system(.title2, design: .rounded))
                Text(restaurant.type ?? "")
                    .font(.system(.body, design: .rounded))
                Text(restaurant.address ?? "")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.gray)
            }
            if restaurant.isFavorite {
                Spacer()
                Image(systemName: "heart.fill")
                    .foregroundColor(.yellow)
            }
        }
        .contextMenu(menuItems: {
            Button {
                isShowingError.toggle()
            } label: {
                Label("Reserve a table", systemImage: "phone")
            }
            Button {
                withAnimation {
                    restaurant.isFavorite.toggle()
                }
            } label: {
                Label(restaurant.isFavorite ? "Remove from favorites" : "Mark as favorite", systemImage: restaurant.isFavorite ? "heart.slash" : "heart")
            }
            Button {
                isShowingDialog.toggle()
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }
            
        })
        .alert("Not yet available", isPresented: $isShowingError) {
            Button("OK") {
                isShowingError.toggle()
            }
            .keyboardShortcut(.defaultAction)
            Button("Cancel", role: .cancel) {
                isShowingError.toggle()
            }
        } message: {
            Text("Sorry, this feature is not available yet. Please retry later.")
        }
        .sheet(isPresented: $isShowingDialog) {
            let defaultText = "Just checking in at \(restaurant.name ?? "")"
            if let imageData = restaurant.image, let imageToShare = UIImage(data: imageData) {
                ActivityView(activityItems: [defaultText, imageToShare])
            } else {
                ActivityView(activityItems: [defaultText])
            }
        }
    }
}

struct FullImageRow: View {
    var imageName: String
    var name: String
    var type: String
    var location: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .cornerRadius(20)
            VStack(alignment: .leading) {
                Text(name)
                    .font(.system(.title2, design: .rounded))
                Text(type)
                    .font(.system(.body, design: .rounded))
                Text(location)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.gray)
            }
        }
    }
}
