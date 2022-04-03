//
//  RestaurantFormViewModel.swift
//  FoodPin
//
//  Created by Fangcheng Song on 2022/3/29.
//

import Foundation
import UIKit

class RestaurantFormViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var type: String = ""
    @Published var address: String = ""
    @Published var phone: String = ""
    @Published var description: String = ""
    @Published var image: UIImage = UIImage()
    
    init(restaurant: Restaurant? = nil) {
        if let restaurant = restaurant {
            self.name = restaurant.name!
            self.type = restaurant.type!
            self.address = restaurant.address!
            self.phone = restaurant.phone!
            self.description = restaurant.summary!
            self.image = UIImage(data: restaurant.image!) ?? UIImage()
        }
    }
}
