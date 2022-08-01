//
//  EmojiField.swift
//  MoneyTracker
//
//  Created by 老人 on 19/07/2022.
//

import Foundation

struct EntryLabel: Identifiable, Hashable {
    var emoji: String
    var text: String
    var type: EntryType
    
    static var demoLabels: [EntryLabel] = [
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
    
    var id = UUID()
}
