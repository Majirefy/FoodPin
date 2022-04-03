//
//  Persistence.swift
//  FoodPin
//
//  Created by Fangcheng Song on 2022/3/23.
//

import CoreData
import UIKit

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "FoodPin")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { persistenceStoreDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let restaurant = Restaurant(context: viewContext)
        
        restaurant.name = "Cafe Deadend"
        restaurant.type = "Coffee & Tea Shop"
        restaurant.address = "G/F, 72 Po Hing Fong, Sheung Wan, Hong Kong"
        restaurant.phone = "232-923423"
        restaurant.summary = "Searching for great breakfast eateries and coffee? This place is for you. We open at 6:30 every morning, and close at 9 PM. We offer espresso and espresso based drink, such as capuccino, cafe latte, piccolo and many more. Come over and enjoy a great meal."
        restaurant.image = (UIImage(named: "cafedeadend")?.pngData())!
        restaurant.isFavorite = false
        
        do {
            try viewContext.save()
        } catch {
            fatalError("Unresolved error \(error.localizedDescription)")
        }
        return result
    }()
    
    static var testData: [Restaurant]? = {
       let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Restaurant")
        return try? PersistenceController.preview.container.viewContext.fetch(fetchRequest) as? [Restaurant]
    }()
}
