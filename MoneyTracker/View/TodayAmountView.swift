//
//  TodayAmountView.swift
//  MoneyTracker
//
//  Created by 老人 on 23/07/2022.
//

import SwiftUI

struct TodayAmountView: View {
    @EnvironmentObject var modelData: ModelData
    var amountAndType: (Double, EntryType) {
        amountInDay(day: Date.now)
    }
    
    func amountInDay(day: Date) -> (Double, EntryType) {
        var entriesInDay: [Entry] {
            modelData.entries.filter({ entry in
                let calendar = Calendar.current
                return calendar.isDate(entry.date, inSameDayAs: day)
            })
        }
        var amount: Double {
            var amount: Double = 0
            for entry in entriesInDay {
                if entry.label.type == .expense {
                    amount -= entry.amount
                } else if entry.label.type == .income {
                    
                }
            }
            return amount
        }
        
        var type: EntryType {
            if amount >= 0 {
                return .income
            } else {
                return .expense
            }
        }
        return (abs(amount), type)
    }
    
    func makeColor(type: EntryType) -> Color {
        var color: Color {
            switch type {
            case .expense:
                return .primary
            case .income:
                return .green
            }
        }
        return color
    }
    
    func makeIcon(with type: EntryType) -> String {
        switch type {
        case .expense:
            return "tray.and.arrow.up"
        case .income:
            return "tray.and.arrow.down"
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: makeIcon(with: amountAndType.1))
                    .opacity(0.7)
                
                Text("Today")
                    .bold()
                    .opacity(0.4)
            }
            
            
            Divider().frame(width: 60)
            
            HStack {
                Text(amountAndType.0, format: .currency(code: "USD"))
                    .font(.system(size: 60))
                    .fontWeight(.thin)
                    .lineLimit(1)
                    .foregroundColor(makeColor(type: amountAndType.1))
            }
        }
        .padding()
    }
}

struct TodayAmountView_Previews: PreviewProvider {
    static var previews: some View {
        TodayAmountView()
            .environmentObject(ModelData())
    }
}
