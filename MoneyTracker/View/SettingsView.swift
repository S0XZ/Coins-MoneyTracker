//
//  SettingsView.swift
//  MoneyTracker
//
//  Created by 老人 on 20/07/2022.
//

import SwiftUI
import WidgetKit

struct SettingsView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var preferData: PreferData    
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    LabelManagerView()
                } label: {
                    HStack {
                        Image(systemName: "face.dashed")
                            .foregroundColor(.accentColor)
                        Text("Label Manage")
                    }
                    .badge(modelData.entryLabels.count)
                }
                
                
//                NavigationLink {
//                    List {
//                        Toggle(isOn: $modelData.isSummaryOn) {
//                            Text("Enable Summary")
//                        }
//                    }
//                    .navigationTitle("Laboratory")
//                    .navigationBarTitleDisplayMode(.inline)
//                    .listStyle(.grouped)
//                } label: {
//                    HStack {
//                        Image(systemName: "wrench.and.screwdriver")
//                        Text("Laboratory")
//                    }
//                }
                
//                Picker(selection: $modelData.colorScheme) {
//                    Text("Light")
//                        .tag(ColorScheme.light)
//                    Text("Dark")
//                        .tag(ColorScheme.dark)
//                } label: {
//                    HStack {
//                        Image(systemName: "lightbulb")
//                        Text("Color Scheme")
//                    }
//                }
                
               
                
                Picker(selection: $preferData.preferColor) {
                    ForEach(preferData.preferColors, id: \.self) { preferColor in
                        HStack {
                            Circle()
                                .foregroundColor(preferColor)
                                .frame(width: 15)
                            Text(LocalizedStringKey(preferColor.description))
                        }
                        .tag(preferColor)
                    }
                    
                } label: {
                    HStack {
                        Image(systemName: "paintbrush")
                            .foregroundColor(.accentColor)
                        Text("Color")
                    }
                }
                
                Toggle(isOn: $preferData.isGroupedByDate) {
                    HStack {
                        Image(systemName: "calendar.day.timeline.left")
                            .foregroundColor(.accentColor)
                        Text("Group entries by date")
                    }
                    
                }
                .tint(.accentColor)
                
                Toggle(isOn: $preferData.isDailyLimitEnbled) {
                    HStack {
                        Image(systemName: "ruler")
                            .foregroundColor(.accentColor)
                        Text("Daily Spend Limit")
                    }
                    
                }
                .tint(.accentColor)
                
//                Section {
//                    NavigationLink {
//                        WidgetSettings()
//                    } label: {
//                        HStack {
//                            Image(systemName: "square.text.square")
//                                .foregroundColor(.accentColor)
//                            Text("Widget")
//                        }
//                    }
//                } footer: {
//                    Text("Widget use the same color as the accent color.")
//                }
                
                Section {
                    
                    NavigationLink {
                        List {
                            Section {
                                HStack(alignment: .top) {
                                    Image(systemName: "bubble.left")
                                        .foregroundColor(.accentColor)
                                    
                                    Text("""
                                         Coins is an open source application made by one developer.
                                         
                                         If you like it, please rate on Appstore, Thank you :)
                                         """)
                                    .foregroundColor(.secondary)
                                }
                            }
                            
                            Section {
                                HStack {
                                    Image(systemName: "envelope").foregroundColor(.accentColor)
                                    Text("Email")
                                    Spacer()
                                    Text("Alfsgox@Gmail.com")
                                        .textSelection(.enabled)
                                }
                            } header:{
                                Text("Contact Me")
                            }footer: {
                                Text("""
Coins is still in develope,
If you have any questions or find some bugs, please let me know.
""")
                            }
                        }
                        .navigationTitle("About")
                    } label: {
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(.accentColor)
                            Text("About")
                        }
                    }
                }
                
            }
            .navigationTitle("Settings")
        }
    }
}

struct WidgetSettings: View {
    @State var widgetSelection: WidgetKind = .today
    enum WidgetKind: String, CaseIterable, Identifiable {
        case goal = "Goal"
        case today = "Today"
        var id: String {rawValue}
    }
    
    var body: some View {
        List {
            if widgetSelection == .goal {
                
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Widget")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker(selection: $widgetSelection) {
                    ForEach(WidgetKind.allCases) {
                        Text($0.rawValue)
                            .tag($0)
                    }
                } label: {
                    
                }
                .pickerStyle(.segmented)
                .frame(width: 175)
            }
        }
    }
}



struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetSettings(widgetSelection: .goal)
        SettingsView()
            .environmentObject(ModelData())
            .environmentObject(PreferData())
        
       
    }
}
