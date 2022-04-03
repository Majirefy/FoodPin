//
//  FoodPinApp.swift
//  Shared
//
//  Created by Fangcheng Song on 2022/3/14.
//

import SwiftUI

@main
struct FoodPinApp: App {
    private let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
