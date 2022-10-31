//
//  Entry.swift
//  MoneyTracker
//
//  Created by 老人 on 02/08/2022.
//

import Foundation
import SwiftUI

struct Entry: Identifiable, Hashable, Codable {
    var entryLabel: EntryLabel
    var amount: Double
    var note: String
    var date: Date
    var isFavorite: Bool

    var entryDate: EntryDate {
        Calendar.makeEntryDate(date: date)
    }
    
    var color: Color {
        ModelData.makeColor(type: entryLabel.labelType)
    }
    
    var opacity: Double {
        ModelData.makeOpacty(type: entryLabel.labelType)
    }
    
    

    static var demoEntries: [Entry] = [ 
        Entry(entryLabel: .demoLabels[0], amount: 100, note: "My favorite Food!!!", date: Calendar.today, isFavorite: true),
        Entry(entryLabel: .demoLabels[1], amount: 20, note: "", date: Calendar.today, isFavorite: false),
        Entry(entryLabel: .demoLabels[2], amount: 40, note: "", date: Calendar.beforeYesterday, isFavorite: false),
        Entry(entryLabel: .demoLabels[3], amount: 40, note: "", date: Calendar.thisYear, isFavorite: false),
        Entry(entryLabel: .demoLabels[9], amount: 400, note: "", date: Calendar.yesterday, isFavorite: false),
        Entry(entryLabel: .demoLabels[10], amount: 500, note: "Thanks for my mother.", date: Calendar.beforeYesterday, isFavorite: false)
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

enum EntryDate: String, Hashable, CaseIterable, Identifiable {
    case future = "Future"
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
