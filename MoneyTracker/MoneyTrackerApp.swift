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
    @StateObject var wantData = WantData()
    @StateObject var preferData = PreferData()
    @State var isPre = false

    @Environment(\.colorScheme) var colorScheme

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .sheet(isPresented: $isPre) {
                        WelcomeScreen(isPre: $isPre)
                    }
                    .onAppear {
                        if !modelData.isWel {
                            isPre = true
                            modelData.isWel = true
                        }
                    }
                    .tint(preferData.preferColor)
                    .accentColor(preferData.preferColor)
                    .environmentObject(preferData)
                    .environmentObject(modelData)
                    .environmentObject(wantData)
    
                
            }
        }
    }
}
