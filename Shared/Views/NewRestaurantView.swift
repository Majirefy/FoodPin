//
//  NewRestaurantView.swift
//  FoodPin
//
//  Created by Fangcheng Song on 2022/3/18.
//

import SwiftUI

struct NewRestaurantView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @ObservedObject private var restaurantFormViewModel: RestaurantFormViewModel
    
    @State private var isShowingPhotoOptions = false
    @State private var photoSource: PhotoSource?
    
    init() {
        let restaurantFormViewModel = RestaurantFormViewModel()
        restaurantFormViewModel.image = UIImage(named: "NewPhoto") ?? UIImage()
        self.restaurantFormViewModel = restaurantFormViewModel
    }
    
    var body: some View {
        NavigationView {
            Form {
                Image(uiImage: restaurantFormViewModel.image)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 200)
                    .background(.red)
                    .onTapGesture {
                        isShowingPhotoOptions.toggle()
                    }
                Section("Information") {
                    TextField("Restaurant Name", text: $restaurantFormViewModel.name)
                    TextField("Restaurant Type", text: $restaurantFormViewModel.type)
                    TextField("Restaurant Address", text: $restaurantFormViewModel.address)
                    TextField("Restaurant Phone", text: $restaurantFormViewModel.phone)
                }
                Section("Description") {
                    TextEditor(text: $restaurantFormViewModel.description)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 100)
                }
            }
            .navigationTitle("New Restaurant")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        save()
                        dismiss()
                    } label: {
                        Text("Save")
                            .font(.headline)
                    }
                }
            }
        }
        .tint(.primary)
        .sheet(isPresented: $isShowingPhotoOptions) {
            PhotoPicker(image: $restaurantFormViewModel.image)
        }
        //        .confirmationDialog("Choose restaurant photo", isPresented: $isShowingPhotoOptions) {
        //            Button {
        //                photoSource = .photoLibrary
        //            } label: {
        //                Text("Photo Library")
        //            }
        //            Button {
        //                photoSource = .camera
        //            } label: {
        //                Text("Camera")
        //            }
        //        } message: {
        //            Text("Choose photo source")
        //        }
    }
    
    private enum PhotoSource: Identifiable {
        case photoLibrary
        case camera
        var id: Int {
            hashValue
        }
    }
    
    private func save() {
        let restaurant = Restaurant(context: managedObjectContext)
        restaurant.name = restaurantFormViewModel.name
        restaurant.type = restaurantFormViewModel.type
        restaurant.address = restaurantFormViewModel.address
        restaurant.phone = restaurantFormViewModel.phone
        restaurant.image = restaurantFormViewModel.image.pngData()
        restaurant.summary = restaurantFormViewModel.description
        restaurant.isFavorite = false
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Failed to save the record")
            print(error.localizedDescription)
        }
        let restaurantCloudStore = RestaurantCloudStore()
        restaurantCloudStore.saveRecordToCloud(restaurant: restaurant)
    }
}

struct NewRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        NewRestaurantView()
    }
}
