//
//  Model.swift
//  MoneyTracker
//
//  Created by 老人 on 19/07/2022.
//

import Foundation
import SwiftUI

final class ModelData: ObservableObject {
    @Published var entries: [Entry] = Entry.demoEntries

    var groupedEntries: [EntryDate: [Entry]] {
        let dictionary: [EntryDate: [Entry]] = Dictionary(grouping: entries, by: {
            $0.entryDate
        })
        return dictionary
    }
    
    @Published var labels: [EntryLabel] = [
        EntryLabel(emoji: "🍔", text: "Food", type: .expense),
        EntryLabel(emoji: "🥤", text: "Drinks", type: .expense),
        EntryLabel(emoji: "👕", text: "Clothing", type: .expense),
        EntryLabel(emoji: "🏠", text: "Home", type: .expense),
        EntryLabel(emoji: "🚕", text: "Taxi", type: .expense),
        EntryLabel(emoji: "🐱", text: "Pets", type: .expense),
        EntryLabel(emoji: "🎉", text: "Party", type: .expense),
        EntryLabel(emoji: "💊", text: "Pills", type: .expense),
        EntryLabel(emoji: "🧐", text: "Other", type: .expense),
        EntryLabel(emoji: "📁", text: "Work", type: .income),
        EntryLabel(emoji: "🎁", text: "Gifts", type: .income)
    ]
    
    var expenseLabels: [EntryLabel] {
        labels.filter({$0.type == .expense})
    }
    var incomeLabels: [EntryLabel] {
        labels.filter({$0.type == .income})
    }
    
    func addEntry(with entry: Entry) {
        withAnimation {
            entries.append(entry)
        }
    }
    
    func addLabel(with label: EntryLabel) {
        withAnimation {
            labels.append(label)
        }
    }
    
    init() {
        fetchToMemory()
    }
    
    func fetchToMemory() {

    }
}

struct Entry: Identifiable, Hashable {
    var label: EntryLabel
    var amount: Double
    var note: String
    var date: Date

    var entryDate: EntryDate {
        let calendar = Calendar.current
                
        if calendar.isDateInToday(self.date) {
            return .today
        } else if calendar.isDateInYesterday(self.date) {
            return .yesterday
        } else if calendar.isDate(date, equalTo: Date(), toGranularity: .weekOfYear),
                  calendar.isDate(date, equalTo: Date(), toGranularity: .year){
            return .thisWeek
        } else if calendar.isDate(date, equalTo: Date(), toGranularity: .month),
                  calendar.isDate(date, equalTo: Date(), toGranularity: .year){
            return .thisMonth
        } else if calendar.isDate(date, equalTo: Date(), toGranularity: .year) {
            return .thisYear
        }
        
        return .earlier
    }
    
    var color: Color {
        switch label.type {
        case .expense:
            return .primary
        case .income:
            return .green
        }
    }
    
    var opacity: Double {
        switch label.type {
        case .expense:
            return 0.5
        case .income:
            return 1.0
        }
    }
    
    static let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    static let beforeYesterday = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
    static let thisYear = Calendar.current.date(byAdding: .day, value: -60, to: Date())!

    static var demoEntries: [Entry] = [
        Entry(label: EntryLabel.demoLabels[0], amount: 100, note: "My favorite Food!!!", date: Date()),
        Entry(label: EntryLabel.demoLabels[1], amount: 200, note: "", date: Date()),
        Entry(label: .demoLabels[2], amount: 400, note: "Exepense", date: beforeYesterday),
        Entry(label: EntryLabel.demoLabels[3], amount: 400, note: "", date: thisYear),
        
        Entry(label: EntryLabel.demoLabels[9], amount: 400, note: "", date: yesterday)
    ]
    
    var id = UUID()
}

extension Entry: Comparable {
    static func < (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.date < rhs.date
    }
    
    static func > (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.date > rhs.date
    }
}

enum EntryType: String, Hashable, CaseIterable, Identifiable {
    case expense = "Expense"
    case income = "Income"
    
    var id: String {rawValue}
}


enum EntryDate: String, Hashable, CaseIterable, Identifiable {
    case today = "Today"
    case yesterday = "Yesterday"
    case thisWeek = "This Week"
    case thisMonth = "This Month"
    case thisYear = "This Year"
    case earlier = "Earlier"
    
    var id: String {rawValue}
}

extension EntryDate : Comparable {
    ///Today > Yesterday> thisWeek > thisMonth > thisYear > eariler
    static func < (lhs: EntryDate, rhs: EntryDate) -> Bool {
        let allCases = EntryDate.allCases
        let lhsIndex = allCases.firstIndex(of: lhs)!
        let rhsIndex = allCases.firstIndex(of: rhs)!
        return lhsIndex > rhsIndex
    }
    
    static func > (lhs: EntryDate, rhs: EntryDate) -> Bool {
        let allCases = EntryDate.allCases
        let lhsIndex = allCases.firstIndex(of: lhs)!
        let rhsIndex = allCases.firstIndex(of: rhs)!
        return lhsIndex < rhsIndex
    }
}
