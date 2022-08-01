//
//  SettingsView.swift
//  MoneyTracker
//
//  Created by 老人 on 20/07/2022.
//

import SwiftUI

struct SettingsView: View {  
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    LabelManagerView()
                } label: {
                    HStack {
                        Image(systemName: "face.dashed")
                        Text("Label Manage")
                    }
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ModelData())
    }
}
