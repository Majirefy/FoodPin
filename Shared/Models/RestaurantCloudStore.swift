//
//  RestaurantCloudStore.swift
//  FoodPin
//
//  Created by Fangcheng Song on 2022/4/3.
//

import CloudKit
import UIKit

class RestaurantCloudStore: ObservableObject {
    @Published var restaurants: [CKRecord] = []
    
    func fetchRestaurants() async throws {
        let container = CKContainer.default()
        let publicDatabase = container.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let results = try await publicDatabase.records(matching: query)
        for result in results.matchResults {
            restaurants.append(try result.1.get())
        }
    }
    
    func fetchRestaurantsWithOperational(completion: @escaping () -> ()) {
        let container = CKContainer.default()
        let publicDatabase = container.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name", "image"]
        queryOperation.queuePriority = .veryHigh
        queryOperation.resultsLimit = 50
        queryOperation.recordMatchedBlock = { (recordID, result) -> Void in
            if let _ = self.restaurants.first(where: { $0.recordID == recordID }) {
                return
            }
            if let restaurant = try? result.get() {
                DispatchQueue.main.async {
                    self.restaurants.append(restaurant)
                }
            }
        }
        queryOperation.queryResultBlock = { result -> Void in
            switch result {
            case .success(_):
                print("Successfully retrieve the data from iCloud.")
            case .failure(let error):
                print("Failed to get data from iCloud: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                completion()
            }
        }
        publicDatabase.add(queryOperation)
    }
    
    func saveRecordToCloud(restaurant: Restaurant) {
        let record = CKRecord(recordType: "Restaurant")
        record.setValue(restaurant.name, forKey: "name")
        record.setValue(restaurant.type, forKey: "type")
        record.setValue(restaurant.address, forKey: "location")
        record.setValue(restaurant.phone, forKey: "phone")
        record.setValue(restaurant.summary, forKey: "description")
        
        let imageData = restaurant.image! as Data
        let originalImage = UIImage(data: imageData)!
        let scalingFactor = (originalImage.size.width > 1024) ? 1204 / originalImage.size.width : 1.0
        let scaledImage = UIImage(data: imageData, scale: scalingFactor)!
        
        let imageFilePath = NSTemporaryDirectory() + restaurant.name!
        let imageFileURL = URL(fileURLWithPath: imageFilePath)
        try? scaledImage.jpegData(compressionQuality: 0.8)?.write(to: imageFileURL)
        
        let imageAsset = CKAsset(fileURL: imageFileURL)
        record.setValue(imageAsset, forKey: "image")
        
        let publicDatabase = CKContainer.default().publicCloudDatabase
        
        publicDatabase.save(record) { _, error in
            if let error = error {
                print(error.localizedDescription.debugDescription)
            }
            
            try? FileManager.default.removeItem(at: imageFileURL)
        }
    }
}
