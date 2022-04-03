//
//  Restaurant.swift
//  FoodPin
//
//  Created by Fangcheng Song on 2022/3/16.
//

import Foundation

extension Restaurant {
    enum Rating: String, CaseIterable {
        case awesome
        case good
        case okay
        case bad
        case terrible
        
        var icon: String {
            switch self {
            case .awesome:
                return "1.circle"
            case .good:
                return "2.circle"
            case .okay:
                return "3.circle"
            case .bad:
                return "4.circle"
            case .terrible:
                return "5.circle"
            }
        }
    }
    
    var rating: Rating? {
        get {
            guard let ratingText = ratingText else { return nil }
            return Rating(rawValue: ratingText)
        }
        set {
            self.ratingText = newValue?.rawValue
        }
    }
}
