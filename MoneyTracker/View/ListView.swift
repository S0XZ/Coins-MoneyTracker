//
//  listView.swift
//  MoneyTracker
//
//  Created by 老人 on 19/07/2022.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var modelData: ModelData
    @State var isSheetPresent: Bool = false
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()

    
    func addEntry() {
        isSheetPresent = true
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Spacer()
                        TodayAmountView()
                        Spacer()
                    }
                }
                
                ForEach(modelData.groupedEntries.keys.sorted(by: >), id: \.self) { key in
                    Section(key.rawValue) {
                        let entries: [Entry] = modelData.groupedEntries[key]!
   
                        ForEach(entries.sorted(by: >)) { entry in
                            NavigationLink {
                                EntryEditView(entry: entry)
                            } label: {
                                EntryRowView(entry: entry)
                            }
                        }
                    }
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Money Tracker")
            .toolbar {
                Button {
                    addEntry()
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
            .sheet(isPresented: $isSheetPresent) {
                EntryAddView(isPresent: $isSheetPresent)
            }
        }
    }
}



struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environmentObject(ModelData())
    }
}
