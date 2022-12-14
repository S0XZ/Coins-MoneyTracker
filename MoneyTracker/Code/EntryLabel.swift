//
//  EmojiField.swift
//  MoneyTracker
//
//  Created by ่ไบบ on 19/07/2022.
//

import Foundation

struct EntryLabel: Identifiable, Hashable, Codable {
    var emoji: String
    var text: String
    var labelType: LabelType
    
    static var demoLabels: [EntryLabel] = [
        EntryLabel(emoji: "๐", text: "Food", labelType: .expense),
        EntryLabel(emoji: "๐ท", text: "Drinks", labelType: .expense),
        EntryLabel(emoji: "๐", text: "Clothing", labelType: .expense),
        EntryLabel(emoji: "๐ ", text: "Home", labelType: .expense),
        EntryLabel(emoji: "๐", text: "Taxi", labelType: .expense),
        EntryLabel(emoji: "๐ฑ", text: "Pets", labelType: .expense),
        EntryLabel(emoji: "๐", text: "Party", labelType: .expense),
        EntryLabel(emoji: "๐", text: "Pills", labelType: .expense),
        EntryLabel(emoji: "๐ง", text: "Other", labelType: .expense),
        EntryLabel(emoji: "๐", text: "Work", labelType: .income),
        EntryLabel(emoji: "๐", text: "Gifts", labelType: .income),
        
        EntryLabel(emoji: "๐ ", text: "Dream", labelType: .expense),
        
        EntryLabel(emoji: "๐", text: "Travel", labelType: .expense),
        EntryLabel(emoji: "๐", text: "Subscription", labelType: .expense),
        EntryLabel(emoji: "๐ฑ", text: "Tech", labelType: .expense),
        EntryLabel(emoji: "๐ฝ", text: "Movie", labelType: .expense),
        EntryLabel(emoji: "๐ฒ", text: "Square meal", labelType: .expense),
        EntryLabel(emoji: "๐จ", text: "Repair", labelType: .expense),
        EntryLabel(emoji: "โค๏ธโ๐ฅ", text: "My love", labelType: .expense),
        EntryLabel(emoji: "๐ฎ", text: "Game", labelType: .expense),
        
        EntryLabel(emoji: "๐ฅ", text: "Medal", labelType: .income),
        EntryLabel(emoji: "๐ฐ", text: "Sale", labelType: .income)
    ]
    
    var id = UUID()
}

enum LabelType: String, Hashable, CaseIterable, Identifiable, Codable {
    case expense = "Expense"
    case income = "Income"
    
    var id: String {rawValue}
}
