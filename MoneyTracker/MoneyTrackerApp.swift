//
//  MoneyTrackerApp.swift
//  MoneyTracker
//
//  Created by 老人 on 19/07/2022.
//

import SwiftUI

@main
struct MoneyTrackerApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
