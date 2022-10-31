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
            Text(entry.entryLabel.emoji)
                .font(.largeTitle)
                .lineLimit(1)
                .frame(width: 40)
                        
            VStack(alignment: .leading) {
                HStack {
                    Text(LocalizedStringKey(entry.entryLabel.text))
                    if entry.isFavorite {
                        Image(systemName: "star.fill")
                            .imageScale(.small)
                            .foregroundColor(.accentColor)
                            .transition(.scale)
                    }
                }
                
                if entry.note.isEmpty {
                    HStack {
                        Image(systemName: "calendar")
                            .imageScale(.small)
                        
                        Text(entry.date, formatter: shortFormatter)
                            
                            .font(.caption)
                    }
                    .opacity(0.5)
                } else {
                    HStack {
                        Image(systemName: "square.and.pencil")
                            .imageScale(.small)
                        
                        Text("\(entry.note)")
                            .font(.caption)
                    }
                    .opacity(0.85)
                }
            }
            
            Spacer()
            
            
            
            DollarAmount(amount: entry.amount, isBold: true)
                .padding(5)
                .opacity(entry.opacity)
                .foregroundColor(entry.color)
            
            Image(systemName: ModelData.makeIcon(with: entry.entryLabel.labelType))
                .imageScale(.small)
                .opacity(entry.opacity)
                .foregroundColor(entry.color)
        }
    }
}

private let shortFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

struct AmountView: View {
    let amount: Double
    
    var body: some View {
        Text(amount, format: .currency(code: "USD").precision(.fractionLength(
            amount>999 ? 0 : 2
        )))
    }
}

struct EntryRowView_Previews: PreviewProvider {
    static var previews: some View {
        EntryRowView(entry: Entry.demoEntries[0])
    }
}
