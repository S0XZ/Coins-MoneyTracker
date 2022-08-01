//
//  DateTest.swift
//  MoneyTracker
//
//  Created by 老人 on 31/07/2022.
//

import SwiftUI

struct DateTest: View {
    let calendar = Calendar.current
    
    
    @State var interval = Calendar.current.dateInterval(of: .weekOfMonth, for: Date.now)
    var range = Calendar.current.range(of: .day, in: .weekOfMonth, for: Date.now)
    var component = Calendar.current.dateComponents([.day, .month], from: Date.now)

    var range2: Range<Int> {
        let startInt = calendar.component(.day, from: interval!.start)
        let endInt = calendar.component(.day, from: interval!.end)
        return startInt ..< endInt
    }
    var thisWeek: [Date] {

        let day = Calendar.current.component(.day, from: Date())
        var weekRange: [Int] = []
        for i in range2 {
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
    
    var body: some View {
        List {
            Text("""
                 ***目前这周的interval:***
                 \(interval.debugDescription)
                 """)
            
            Text("""
                 ***目前这周的range:***
                 \(range.debugDescription)
                 """)
            
            Text("""
                 ***查询「今天」是第几个月， 第几天？:***
                 \(component.debugDescription)
                 """)

//            Text(range2.debugDescription)
        }
        .listStyle(.grouped)
    }
}

struct DateTest_Previews: PreviewProvider {
    static var previews: some View {
        DateTest()
    }
}
