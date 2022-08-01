//
//  EntryRowView.swift
//  MoneyTracker
//
//  Created by 老人 on 21/07/2022.
//

import SwiftUI

struct EntryRowView: View {
    var entry: Entry
    
    var body: some View {
        HStack() {
            Text(entry.label.emoji)
                .font(.largeTitle)
            
            Divider()
            
            VStack(alignment: .leading) {
                Text(entry.label.text)
                
                if !entry.note.isEmpty {
                    Text("\(entry.note)")
                        .opacity(0.5)
                        .font(.caption)
                }
            }
            
            Spacer()
            
            Text(entry.amount, format: .currency(code: "USD"))
                .bold()
                .padding(5)
                .opacity(entry.opacity)
                .foregroundColor(entry.color)
        }
    }
}

struct EntryRowView_Previews: PreviewProvider {
    static var previews: some View {
        EntryRowView(entry: Entry.demoEntries[0])
    }
}
