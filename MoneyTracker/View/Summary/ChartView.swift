//
//  ChartView.swift
//  MoneyTracker
//
//  Created by 老人 on 27/07/2022.
//

import SwiftUI

struct ChartView: View {
    @EnvironmentObject var modelData: ModelData
    let calendar = Calendar.current
    var weekIndex: Int = 0
    
    //some View stuff...
    var maxAmount: Double {
        var amounts: [Double] = []
        for date in calendar.daysWithSameWeekOfYear(as: .now) {
            amounts.append(amountInDay(day: date))
        }
        var maxAmount: Double { amounts.max() ?? 0 }
        return maxAmount
    }
    
    let maxHeight: Double = 170
    
    private func heightInAmount(amount: Double) -> Double {
        if maxAmount == 0 {return 0}
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
                if entry.entryLabel.labelType == self.labelType {
                    amount += entry.amount
                }
            }
            return amount
        }
        return amount
    }
    
    @Binding var labelType: LabelType
    var color: Color {
        switch labelType {
        case .expense:
            return .gray
        case .income:
            return .accentColor
        }
    }
    
    func fontOpacity(_ amount: Double) -> Double{
        if amount > 0 {
            return 0.9
        } else {
            return 0.35
        }
    }
    
    func circleOpacity(_ amount: Double) -> Double {
        amount == maxAmount ? (amount > 0 ? 1 : 0) : 0
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(calendar.dayWithWeekOfYear(as: .now, with: weekIndex)
                            , id: \.self) { date in
                    let amount = amountInDay(day: date)
                    
                    VStack {
                        Text(date, format: .dateTime.weekday(.abbreviated))
                            .font(.system(size: 16))
                            .opacity(0.7)
                        
                        Circle()
                            .frame(width: 5, height: 5)
                            .foregroundColor(color)
                            .opacity(circleOpacity(amount))
                            .padding(-2)

                        RoundedRectangle(cornerRadius: 5)
                            .frame(height: maxHeight)
                            .opacity(0.1)
                            .overlay(alignment: .bottom) {
                                Rectangle()
                                    .foregroundColor(color)
                                    .frame(height: heightInAmount(amount: amount))
                            }
                            .mask {
                                RoundedRectangle(cornerRadius: 5)
                                    
                            }
                            .padding(.horizontal, 6)
                        
                        Text("$" + Int(amount).description)
                            .font(.system(size: 14))
                            .fixedSize()
                            .opacity(fontOpacity(amount))
                            .animation(nil)
                    }
                }
            }
            .padding()
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(weekIndex: 0, labelType: .constant(.expense))
            .environmentObject(ModelData())
    }
}
