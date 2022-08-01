//
//  ChartView.swift
//  MoneyTracker
//
//  Created by 老人 on 27/07/2022.
//

import SwiftUI

struct ChartView: View {
    @EnvironmentObject var modelData: ModelData
    var thisWeek: [Date] {
        guard let range = Calendar.current.range(of: .day, in: .weekOfMonth, for: Date()) else {return []}

        let day = Calendar.current.component(.day, from: Date())
        var weekRange: [Int] = []
        for i in range {
            weekRange.append(i - day)
        }
        
        var dates: [Date] = []
        for i in weekRange {
            if let date = Calendar.current.date(byAdding: .day, value: i, to: Date.now) {
                dates.append(date)
            } else {
                dates.append(Date.now)
            }
        }
        
        return dates
    }
    
    
    //some View stuff...
    var maxAmount: Double {
        var amounts: [Double] = []
        for date in thisWeek {
            amounts.append(amountInDay(day: date))
        }
        var maxAmount: Double { amounts.max() ?? 0 }
        return maxAmount
    }
    
    let maxHeight: Double = 170
    
    private func heightInAmount(amount: Double) -> Double {
        return amount/maxAmount * maxHeight
    }
    //end of view stuff...
    
    private func amountInDay(day: Date) -> Double {
        var entriesInDay: [Entry] {
            modelData.entries.filter({ entry in
                let calendar = Calendar.current
                return calendar.isDate(entry.date, inSameDayAs: day)
            })
        }
        var amount: Double {
            var amount: Double = 0
            for entry in entriesInDay {
                if entry.label.type == self.type {
                    amount += entry.amount
                }
            }
            return amount
        }
        return amount
    }
    
    @State var type: EntryType = .expense
    var color: Color {
        switch type {
        case .expense:
            return .gray
        case .income:
            return .green
        }
    }
    
    var body: some View {
        let typePicker =
        Picker("Type", selection: $type) {
            Image(systemName: "tray.and.arrow.up")
                .tag(EntryType.expense)
            Image(systemName: "tray.and.arrow.down")
                .tag(EntryType.income)
        }
        .frame(width: 140)
        .pickerStyle(.segmented)
        
        VStack {
            
            typePicker
            HStack {
                ForEach(thisWeek, id: \.self) { date in
                    VStack {
                        Text(date, format: .dateTime.weekday())
                            .lineLimit(1)
                            .opacity(0.7)

                        RoundedRectangle(cornerRadius: 5)
                            .frame(height: maxHeight)
                            .opacity(0.1)
                            .overlay(alignment: .bottom) {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(color)
                                    .blendMode(.multiply)
                                    .frame(height: heightInAmount(amount: amountInDay(day: date)))
                            }
                            .padding(.horizontal, 6)
                        
                        Text(amountInDay(day: date), format: .currency(code: "USD").precision(.fractionLength(0)))
                            .bold()
                            .lineLimit(1)

                            .opacity(0.9)
                    }
                }
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
            .environmentObject(ModelData())
    }
}
