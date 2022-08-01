//
//  ContentView.swift
//  MoneyTracker
//
//  Created by 老人 on 19/07/2022.
//

import SwiftUI

struct ContentView: View {
    @State var tab: Tab = .list
    
    var body: some View {
        TabView(selection: $tab) {
            ListView()
                .tag(Tab.list)
                .tabItem() {
                    Label("List", systemImage: "list.bullet")
                }
            
            SummaryView()
                .tag(Tab.summary)
                .tabItem {
                    Label("Summary", systemImage: "chart.bar.xaxis")
                }
            
            SettingsView()
                .tag(Tab.settings)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
    
    enum Tab {
        case list
        case summary
        case settings
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
