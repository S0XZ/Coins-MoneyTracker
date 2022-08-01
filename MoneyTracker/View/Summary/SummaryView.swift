//
//  SummaryView.swift
//  MoneyTracker
//
//  Created by 老人 on 21/07/2022.
//

import SwiftUI

struct SummaryView: View {
    @EnvironmentObject var modelData: ModelData
    @State var type: EntryType = .expense

    var thisWeek: [Date] {
        let range = Calendar.current.range(of: .day, in: .weekOfMonth, for: Date())!
        var dates: [Date] = []
        for i in range {
            let date = Calendar.current.date(bySetting: .day, value: i, of: Date())!
            dates.append(date)
        }
        
        return dates
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
                    amount += entry.amount
                }
            }
            return amount
        }
        var type: EntryType {
            if amount > 0 {
                return .income
            } else {
                return .expense
            }
        }
        return (amount, type)
    }
    
    var entriesInWeek: [Entry] {
        modelData.entries.filter({ entry in
            let calendar = Calendar.current
            return calendar.isDate(entry.date, equalTo: Date.now, toGranularity: .weekOfYear) &&
            calendar.isDate(entry.date, equalTo: Date.now, toGranularity: .year)
            
        })
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
        
        NavigationView {
            ZStack {
                List {
                    Rectangle()
                        .frame(height: 300)
                        .opacity(0)
                    
                    ForEach(entriesInWeek) { entry in
                        EntryRowView(entry: entry)
                    }
                }
                
                VStack {
                    HStack {
                        ForEach(thisWeek, id: \.self) { date in
                            VStack {
                                Text(date, format: .dateTime.weekday())
                                    .lineLimit(1)
                                    .opacity(0.7)
                                
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(height: 170)
                                    .opacity(0.1)
                                    .overlay {
                                        VStack() {
                                            Spacer()
                                            RoundedRectangle(cornerRadius: 5)
                                                .foregroundColor(.green)
                                                .blendMode(.multiply)
                                                .frame(height: amountInDay(day: date).0)
                                        }
                                    }
                                    .padding(.horizontal, 6)
                                    
                                Text(amountInDay(day: date).0, format: .currency(code: "USD").precision(.fractionLength(0)))
                                    .bold()
                                    .lineLimit(1)
                                    
                                    .opacity(0.9)
                                    .foregroundColor(makeColor(type: amountInDay(day: date).1))
                            }
                        }
                    }
                    .padding(20)
                    .background(.ultraThinMaterial)
                    
                    Divider() .padding(.top, -9)
                    
                    Spacer()
                }

            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    typePicker
                }
            }
            .navigationTitle("This Week")
            .navigationBarTitleDisplayMode(.large)
        }
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
  
  func makeOpacity(type: EntryType) -> Double {
      var opacity: Double {
          switch type {
          case .expense:
              return 0
          case .income:
              return 1.0
          }
      }
      return opacity
  }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
            .environmentObject(ModelData())
    }
}
