//
//  EmojiField.swift
//  MoneyTracker
//
//  Created by 老人 on 19/07/2022.
//

import Foundation

struct EntryLabel: Identifiable, Hashable, Codable {
    var emoji: String
    var text: String
    var labelType: LabelType
    
    static var demoLabels: [EntryLabel] = [
        EntryLabel(emoji: "🍔", text: "Food", labelType: .expense),
        EntryLabel(emoji: "🍷", text: "Drinks", labelType: .expense),
        EntryLabel(emoji: "👕", text: "Clothing", labelType: .expense),
        EntryLabel(emoji: "🏠", text: "Home", labelType: .expense),
        EntryLabel(emoji: "🚕", text: "Taxi", labelType: .expense),
        EntryLabel(emoji: "🐱", text: "Pets", labelType: .expense),
        EntryLabel(emoji: "🎉", text: "Party", labelType: .expense),
        EntryLabel(emoji: "💊", text: "Pills", labelType: .expense),
        EntryLabel(emoji: "🧐", text: "Other", labelType: .expense),
        EntryLabel(emoji: "📁", text: "Work", labelType: .income),
        EntryLabel(emoji: "🎁", text: "Gifts", labelType: .income),
        
        EntryLabel(emoji: "🌠", text: "Dream", labelType: .expense),
        
        EntryLabel(emoji: "🏝", text: "Travel", labelType: .expense),
        EntryLabel(emoji: "🗓", text: "Subscription", labelType: .expense),
        EntryLabel(emoji: "📱", text: "Tech", labelType: .expense),
        EntryLabel(emoji: "📽", text: "Movie", labelType: .expense),
        EntryLabel(emoji: "🍲", text: "Square meal", labelType: .expense),
        EntryLabel(emoji: "🔨", text: "Repair", labelType: .expense),
        EntryLabel(emoji: "❤️‍🔥", text: "My love", labelType: .expense),
        EntryLabel(emoji: "🎮", text: "Game", labelType: .expense),
        
        EntryLabel(emoji: "🥇", text: "Medal", labelType: .income),
        EntryLabel(emoji: "💰", text: "Sale", labelType: .income)
    ]
    
    var id = UUID()
}

enum LabelType: String, Hashable, CaseIterable, Identifiable, Codable {
    case expense = "Expense"
    case income = "Income"
    
    var id: String {rawValue}
}
