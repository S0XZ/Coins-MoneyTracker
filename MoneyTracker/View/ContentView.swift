//
//  ContentView.swift
//  MoneyTracker
//
//  Created by 老人 on 19/07/2022.
//

import SwiftUI

struct ContentView: View {
    @State var tab: Tab = .list
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        
        TabView(selection: $tab) {
            ListView()
                .tag(Tab.list)
                .tabItem() {
                    Label("Entries", systemImage: "dollarsign.circle")
                        .symbolRenderingMode(.hierarchical)
                }
            
            PiggyBank()
                .tag(Tab.piggyBank)
                .tabItem {
                    Label("Bank", systemImage: "tray.and.arrow.down")
                }

            SummaryView()
                .tag(Tab.summary)
                .tabItem {
                    Label("Summary", systemImage: "chart.bar.xaxis")
                        .symbolRenderingMode(.hierarchical)
                }

            SettingsView()
                .tag(Tab.settings)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                        .symbolRenderingMode(.hierarchical)
                }
        }
    }
    
    enum Tab {
        case list
        case piggyBank
        case summary
        case settings
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(WantData())
            .environmentObject(PreferData())
            .environmentObject(ModelData())
    }
}
