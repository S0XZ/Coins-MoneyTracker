//
//  listView.swift
//  MoneyTracker
//
//  Created by 老人 on 19/07/2022.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var preferData: PreferData
    @State var isSheetPresent: Bool = false
    @State var isAddError: Bool = false
    @State var isAddLabel: Bool = false
    @State var isDeletingEntry: Bool = false
    @State var selectEntry: Entry?
    
    @State var isSortByDateBackward: Bool = false
    @State var entryFilter: EntryFilter = .none
    var isFiltering: Bool {
        entryFilter != .none
    }
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()

    
    func addEntry() {
        guard !modelData.entryLabels.isEmpty else {
            isAddError = true
            return
        }
        isSheetPresent = true
    }
    
    let addErrorTitle: LocalizedStringKey = "No Labels"
    let addErrorMessage: LocalizedStringKey = "Please add at least one Label."
    
    var body: some View {
        NavigationView {
            List {
                if !modelData.groupedEntries.isEmpty, !isFiltering {
                    Section {
                        HStack {
                            Spacer()
                            TodayAmountView(amount: modelData.amountInDay(day: Date.now).0,
                                            labelType: modelData.amountInDay(day: .now).1)
                            Spacer()
                        }
                        
                        if modelData.amountInDay(day: .now).1 == .expense, preferData.isDailyLimitEnbled {
                            DailyThreshold()
                                .frame(height: 50)
                        }
                    }
                }
                
                if !preferData.isGroupedByDate {
                    ForEach(ModelData.filteredEntries(entries: modelData.entries, entryFilter: entryFilter).sorted(by: >)) { entry in
                        NavigationLink {
                            EntryEditView(labelType: entry.entryLabel.labelType, entry: entry)
                        } label: {
                            EntryRowView(entry: entry)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                isDeletingEntry = true
                                selectEntry = entry
                            } label: {
                                Label("Delete", systemImage: "trash")
                                    
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
                                modelData.favorite(entry)
                            } label: {
                                Image(systemName: !entry.isFavorite ? "star" : "star.slash.fill")
                                    
                            }
                            .tint(.accentColor)
                        }
                    }
                }
                
                if preferData.isGroupedByDate {
                    ForEach(modelData.groupedEntries.keys.sorted(by: >), id: \.self) { key in
                        Section {
                            let entries: [Entry] = ModelData.filteredEntries(
                                entries: modelData.groupedEntries[key]!,
                                entryFilter: entryFilter)
       
                            ForEach(entries.sorted(by: >)) { entry in
                                NavigationLink {
                                    EntryEditView(labelType: entry.entryLabel.labelType, entry: entry)
                                } label: {
                                    EntryRowView(entry: entry)
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        isDeletingEntry = true
                                        selectEntry = entry
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                            
                                    }
                                }
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button {
                                        modelData.favorite(entry)
                                    } label: {
                                        Image(systemName: !entry.isFavorite ? "star" : "star.slash.fill")
                                            
                                    }
                                    .tint(.accentColor)
                                }
                            }
                        } header: {
                            Text(LocalizedStringKey(key.rawValue))
                                .bold()
                        }
                    }
                }
            }
            .navigationTitle(isFiltering ? LocalizedStringKey(entryFilter.rawValue) : "Coins")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        addEntry()
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Menu {
                        Picker(selection: $entryFilter) {
                            Label("Favorite Only", systemImage: "star")
                                .tag(EntryFilter.favoriteOnly)
                            
                            Label("Expense Only", systemImage: ModelData.makeIcon(with: .expense))
                                .tag(EntryFilter.expenseOnly)
                            
                            Label("Income Only", systemImage: ModelData.makeIcon(with: .income))
                                .tag(EntryFilter.IncomeOnly)
                            
                            Text("None")
                                .tag(EntryFilter.none)
                        } label: {
                            Label("Filter", systemImage: isFiltering ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                        }
                    } label: {
                        Label("Filter", systemImage: isFiltering ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                    }
                    
//                    Menu {
//                        Menu {
//                            Picker(selection: $isSortByDateBackward) {
//                                Label("Forward", systemImage: "arrow.up.circle").tag(false)
//                                Label("Backward", systemImage: "arrow.down.circle").tag(true)
//                            } label: {
//                                Label("Sort By Date", systemImage: "calendar")
//                            }
//                        } label: {
//                            Label("Sort By Date", systemImage: "calendar")
//                        }
//                    } label: {
//                        Label("Sort", systemImage: "arrow.up.arrow.down.circle")
//                    }
                    
                }
            }
            .sheet(isPresented: $isSheetPresent) {
                EntryAddView(entryLabel: modelData.entryLabels[0])
            }
            .sheet(isPresented: $isAddLabel) {
                LabelAddView()
            }
            .alert(addErrorTitle, isPresented: $isAddError) {
                Button("OK") {}
                Button("Add") {
                    isAddLabel.toggle()
                }
            } message: {
                Text(addErrorMessage)
            }
            .alert("Alert", isPresented: $isDeletingEntry) {
                Button("Delete", role: .destructive) {
                    if let selectEntry = selectEntry {
                        withAnimation {
                            modelData.deleteEntry(selectEntry)
                        }
                    }
                }
            } message: {
                Text("Delete Entry?")
            }
        }
        .overlay {
            if modelData.groupedEntries.isEmpty {
                VStack {
                    NoEntry()
                    
                    MyButton(text: "Add Entry", isBackgroundOn: true, action: addEntry)
                        .padding()
                }
            }
        }
    }
}

enum EntryFilter: String, CaseIterable, Identifiable, Hashable {
    case favoriteOnly = "Favorite Only"
    case expenseOnly = "Expense Only"
    case IncomeOnly = "Income Only"
    case none = "None"
    
    var id: String {rawValue}
}



struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environmentObject(PreferData())
            .environmentObject(ModelData())
    }
}

struct NoEntry: View {
    var body: some View {
        VStack {
            Image(systemName: "dollarsign.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 75)
                .padding()
            Text("No Entries")
                .font(.title3)
        }
        .foregroundStyle(.tertiary)
    }
}
