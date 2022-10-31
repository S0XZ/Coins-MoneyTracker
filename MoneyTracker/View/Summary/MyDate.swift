//
//  MyDate.swift
//  Coins
//
//  Created by 老人 on 28/08/2022.
//

import Foundation

extension Calendar {
    func intervalOfWeek(for date: Date) -> DateInterval? {
        dateInterval(of: .weekOfYear, for: date)
      }
    
    func startOfWeek(for date: Date) -> Date? {
        intervalOfWeek(for: date)?.start
      }
    
    func endOfWeek(for date: Date) -> Date? {
        intervalOfWeek(for: date)?.end
    }
    
    func dayWithWeekOfYear(as date: Date, with week: Int) -> [Date] {
        let calendar = Calendar.current
        guard let startOfThisWeek = startOfWeek(for: date) else {
          return []
        }
        guard let startOfWeek = calendar.date(byAdding: .day, value: 7*week, to: startOfThisWeek) else {
            return []
          }
        
        return (0...6).map { Calendar.current.date(byAdding: .day, value: $0, to: startOfWeek) }.compactMap{$0}
    }
    
    func daysWithSameWeekOfYear(as date: Date) -> [Date] {
        guard let startOfWeek = startOfWeek(for: date) else {
          return []
        }
        
        //方法1
        return (0 ... 6).reduce(into: []) { result, daysToAdd in
          result.append(Calendar.current.date(byAdding: .day, value: daysToAdd, to: startOfWeek))
        }
        .compactMap { $0 }

        //方法2(low到爆）
        var week: [Date] = []
        for i in 0...6 {
            week.append(Calendar.current.date(byAdding: .day, value: i, to: startOfWeek)!)
        }
        return week.compactMap{$0}
        
        //方法3
        return (0...6).map { Calendar.current.date(byAdding: .day, value: $0, to: startOfWeek) }.compactMap{$0}
        
      }
    
    func makeDateDescription(date: Date) -> String {
        let calendar: Calendar = .current
        let monthSymbols: [String] = calendar.shortMonthSymbols
        let description: String = monthSymbols[calendar.component(.month, from: date) - 1] +
        ", " +
        calendar.component(.day, from: date).formatted()
        
        return description
    }
    
    
    static func makeEntryDate(date: Date) -> EntryDate {
        let calendar = Calendar.current
        
        if date > .now {
            return .future
        }
        else if calendar.isDateInToday(date) {
            return .today
        } else if calendar.isDateInYesterday(date) {
            return .yesterday
        } else if calendar.isDate(date, equalTo: Date(), toGranularity: .weekOfYear),
                  calendar.isDate(date, equalTo: Date(), toGranularity: .year){
            return .thisWeek
        } else if calendar.isDate(date, equalTo: Date(), toGranularity: .month),
                  calendar.isDate(date, equalTo: Date(), toGranularity: .year){
            return .thisMonth
        } else if calendar.isDate(date, equalTo: Date(), toGranularity: .year) {
            return .thisYear
        }
        
        return .earlier
    }
    
    static let today = Calendar.current.startOfDay(for: .now)
    static let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
    static let beforeYesterday = Calendar.current.date(byAdding: .day, value: -2, to: today)!
    static let thisYear = Calendar.current.date(byAdding: .day, value: -60, to: today)!
}
