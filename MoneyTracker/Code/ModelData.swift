//
//  Model.swift
//  MoneyTracker
//
//  Created by 老人 on 19/07/2022.
//

import Foundation
import SwiftUI
import WidgetKit

final class ModelData: ObservableObject {
    @Published var entries: [Entry] = [] {
        didSet {
            saveEntry()
            reloadWidget()
            print("Entry Saved")
        }
    }
    @Published var entryLabels: [EntryLabel] = EntryLabel.demoLabels {
        didSet {
            saveLabel()
            print("Label Saved")
        }
    }
    
    //For the Widgets
    @AppStorage("todayAmount", store: UserDefaults(suiteName: "group.older.coins")) var todayAmount: Double = 0
    @AppStorage("todayAmountType", store: UserDefaults(suiteName: "group.older.coins")) var todayAmountType: LabelType = .expense

    func reloadWidget() {
        self.todayAmount = amountInDay(day: .now).0
        self.todayAmountType = amountInDay(day: .now).1
        WidgetCenter.shared.reloadTimelines(ofKind: "Coins_Widget")
    }
    
    static func filteredEntries(entries: [Entry], entryFilter: EntryFilter) -> [Entry] {
        let entries = entries.filter { entry in
            switch entryFilter {
            case .favoriteOnly:
                return entry.isFavorite
            case .expenseOnly:
                return entry.entryLabel.labelType == .expense
            case .IncomeOnly:
                return entry.entryLabel.labelType == .income
            case .none:
                return true
            }
        }
        return entries
    }

    var groupedEntries: [EntryDate: [Entry]] {
        let dictionary: [EntryDate: [Entry]] = Dictionary(grouping: entries, by: {
            $0.entryDate
        })
        return dictionary
    }
    
    //猪猪储钱罐
    var totalAmount: Double {
        var amount: Double = 0
        for entry in entries {
            if entry.entryLabel.labelType == .expense {
                amount -= entry.amount
            } else if entry.entryLabel.labelType == .income {
                amount += entry.amount
            }
        }
        return amount + initalAmount
    }
    
    @AppStorage("goal") var goal: Double = 1000
    @AppStorage("initalAmount") var initalAmount: Double = 100
    var progress: Double {
        min(max(totalAmount, 0)/goal, 1)
    }
    var alreadyProgress: Double {
        min(max(initalAmount, 0)/goal, progress)
    }
    var progressText: LocalizedStringKey {
        if progress < 50 {
            return "Need to make an effort"
        } else {
            return "I am closed!"
        }
    }
    
    //Summary
    func entryMostByWeek(type: LabelType, weekIndex: Int) -> Entry? {
        var amount: Double = 0
        var mostEntry: Entry?
        for entry in entriesByWeek(type: type, week: weekIndex) {
            if entry.amount > amount {
                amount = entry.amount
                mostEntry = entry
            }
        }
        return mostEntry
    }
    
    func totalAmountByWeek(type: LabelType, weekIndex: Int) -> Double {
        var amount: Double = 0
        for entry in entriesByWeek(type: type, week: weekIndex) {
            amount += entry.amount
        }
        return amount
    }
    
    func sortedEntries(type: LabelType) -> [Entry] {
        entries.filter({
            $0.entryLabel.labelType == type
        })
    }
    
    func entriesByWeek(type: LabelType, week: Int) -> [Entry] {
        sortedEntries(type: type).filter({ entry in
            return Calendar.current.dayWithWeekOfYear(as: .now, with: week).reduce(into: false) { result, weekday in
                if Calendar.current.isDate(entry.date, inSameDayAs: weekday) { result = true } 
            }
        })
    }
    
    func makeWeekIndexs() -> Array<Int> {
        let range: Range<Int> = (-10..<0)
        var weekIndexs: [Int] = range.reduce(into: []) {result, index in
            //-10 -> -1,
            //-9 -> -2,
            // ...
            let oppIndex: Int = range.startIndex - index - 1
            if !entriesByWeek(type: .expense, week: oppIndex).isEmpty ||
                !entriesByWeek(type: .income, week: oppIndex).isEmpty {
                result.append(oppIndex)
            }
        }
        weekIndexs.insert(0, at: 0)
        return weekIndexs
        
    }
    
    //是否已经展示过欢迎界面
    @AppStorage("isWel") var isWel: Bool = false
    
    //Permanent storage
    @AppStorage("entry") var entryData: Data = Data()
    @AppStorage("label") var labelData: Data = Data()
    
    func saveLabel() {
        if let labelData = try? JSONEncoder().encode(self.entryLabels) {
            self.labelData = labelData
        }
    }
    
    func saveEntry() {
        if let entryData = try? JSONEncoder().encode(self.entries) {
            self.entryData = entryData
        }
    }
    
    func fetch() {
        if let decodedEntry = try? JSONDecoder().decode([Entry].self, from: self.entryData) {
            self.entries = decodedEntry
        }
        if let decodedLabel = try? JSONDecoder().decode([EntryLabel].self, from: self.labelData) {
            self.entryLabels = decodedLabel
        }
    }
    
    init() {
        fetch()
    }
    
    
    //Functions
    static func makeColor(type: LabelType) -> Color {
        switch type {
        case .expense:
            return Color.primary
        case .income:
            return Color.accentColor
        }
    }
    
    static func makeOpacty(type: LabelType) -> Double {
        switch type {
        case .expense:
            return 0.5
        case .income:
            return 1
        }
    }
    
    static func makeIcon(with type: LabelType) -> String {
        switch type {
        case .expense:
            return "tray.and.arrow.up"
        case .income:
            return "tray.and.arrow.down"
        }
    }
    
    //Other Function
    func amountInDay(day: Date) -> (Double, LabelType) {
        var entriesInDay: [Entry] {
            entries.filter({ entry in
                let calendar = Calendar.current
                return calendar.isDate(entry.date, inSameDayAs: day)
            })
        }
        var amount: Double {
            var amount: Double = 0
            for entry in entriesInDay {
                if entry.entryLabel.labelType == .expense {
                    amount -= entry.amount
                } else if entry.entryLabel.labelType == .income {
                    amount += entry.amount
                }
            }
            return amount
        }
        
        var type: LabelType {
            amount > 0 ? .income : .expense
        }
        return (abs(amount), type)
    }
    
    func sortedLabels(type: LabelType) -> Binding<[EntryLabel]> {
        Binding<[EntryLabel]>(
            get: {
                self.entryLabels
                    .filter {
                        switch type {
                        case .expense:
                            return $0.labelType == .expense
                        case .income:
                            return $0.labelType == .income
                        }
                    }
            },
            set: { entryLabels in
                for entryLabel in entryLabels {
                    if let index = self.entryLabels.firstIndex(where: { $0.id == entryLabel.id }) {
                        self.entryLabels[index] = entryLabel
                    }
                }
            }
        )
    }
    
    func addEntry(with entry: Entry) {
        withAnimation(.easeOut) {
            entries.append(entry)
        }
    }
    
    func addLabel(with label: EntryLabel) {
        withAnimation(.easeOut) {
            entryLabels.append(label)
        }
    }
    
    func deleteLabel(_ label: EntryLabel) {
        withAnimation(.easeOut) {
            entryLabels.removeAll {$0.id == label.id}
        }
    }

    func deleteEntry(_ entry: Entry) {
        withAnimation(.easeOut) {
            entries.removeAll { $0.id == entry.id }
        }
    }
    
    func favorite(_ entry: Entry) {
        withAnimation(.easeOut) {
            guard let index = entries.firstIndex(where: { $0.id == entry.id }) else {return}
            entries[index].isFavorite.toggle()
        }
    }
    
    
}

extension Animation {
    static func crazy() -> Animation {
        return Animation.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.5)
    }
    static func slow() -> Animation {
        return Animation.spring(response: 0.7, dampingFraction: 1, blendDuration: 0.5)
    }
}


