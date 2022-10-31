//
//  SummaryView.swift
//  MoneyTracker
//
//  Created by 老人 on 21/07/2022.
//

import SwiftUI

struct SummaryView: View {
    @EnvironmentObject var modelData: ModelData
    @State var dateComponentOfSummary: DateComponentOfSummary = .week
    @State var labelType: LabelType = .expense
    @State var weekIndex: Int = 0
    func weekString(weekIndex: Int) -> LocalizedStringKey {
        switch weekIndex {
        case 0:
            return "This Week"
        case -1:
            return "Last Week"
        default:
            let calendar: Calendar = Calendar.current
            
            guard let startOfThisWeek =  calendar.startOfWeek(for: .now) else {return ""}
            guard let startOfWeek = calendar.date(byAdding: .day, value: weekIndex*7, to: startOfThisWeek) else {return ""}
            guard let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek) else {return ""}
            
            let startOfWeekString: String = calendar.makeDateDescription(date: startOfWeek)
            let endOfWeekString: String = calendar.makeDateDescription(date: endOfWeek)
            return "\(startOfWeekString) - \(endOfWeekString)"
            
        }
    }
    
    let verticalPad: CGFloat = 2
    let horizontalPad: CGFloat = 20
    
    var body: some View {
        NavigationView {
            ScrollView {
  
                MySpacer()
                HStack {
                    Menu {
                        Picker(selection: $weekIndex) {
                            ForEach(modelData.makeWeekIndexs(), id: \.self) {
                                Text(weekString(weekIndex: $0)).tag($0)
                            }
                        } label: {}
                    } label: {
                        HStack {
                            Text(weekString(weekIndex: weekIndex))
                                .font(.title3)
                            Image(systemName: "chevron.right")
                        }
                    }

                    Spacer()
                }
                .animation(nil)
                .padding(.horizontal, horizontalPad)
                .padding(.vertical, verticalPad)
                
                Group {
                    MyCell()
                        .frame(height: 270)
                        .overlay {
                            ChartView(weekIndex: weekIndex, labelType: $labelType)
                                .animation(.slow())
                        }
                        .padding(.horizontal, horizontalPad)
                        .padding(.vertical, verticalPad)
                    
                    MySpacer()
                }
                
                Group {
                    HStack {
                        //Most Entry
                        MyCell().frame(height: 150)
                            .overlay {
                                Button {
                                    
                                } label: {
                                    EntryItemView(
                                        entry: modelData.entryMostByWeek(
                                            type: labelType,
                                            weekIndex: weekIndex),
                                        labelType: labelType)
                                }
                                .buttonStyle(.plain)
                            }
                        
                        Spacer().frame(width: 20)
                        
                        //Total Amount
                        MyCell().frame(height: 150)
                            .overlay {
                                TotalAmountThisWeek(
                                    labelType: labelType,
                                    amount: modelData.totalAmountByWeek(
                                        type: labelType,
                                        weekIndex: weekIndex))
                            }
                    }
                    .padding(.horizontal, horizontalPad)
                    .padding(.vertical, verticalPad)
                    
                    MySpacer()
                }
                
                Group {
                    WeekList(labelType: labelType, weekIndex: weekIndex)
                    .padding(.horizontal, horizontalPad)
                    .padding(.vertical, verticalPad)
                    
                    MySpacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TypePicker(labelType: $labelType)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Picker(selection: $dateComponentOfSummary) {
                        ForEach(DateComponentOfSummary.allCases) {
                            Text($0.rawValue).tag($0)
                        }
                    } label: {
                        
                    }
                }
            }
            .navigationTitle(LocalizedStringKey(labelType.rawValue + " Summary"))
            .background(Color(UIColor.systemGroupedBackground))
        }
        
    }
}

enum DateComponentOfSummary: LocalizedStringKey, Identifiable, CaseIterable {
//    case month = "Month"
    case week = "Week"
    var id: String {"\(rawValue)"}
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
            .environmentObject(ModelData())
    }
}

struct EntryItemView: View {
    var entry: Entry?
    var labelType: LabelType
    
    var body: some View {
        VStack {
            Text(LocalizedStringKey(
                "Most " + labelType.rawValue
            ))
            Spacer()
            if let entry = entry {
                Text(entry.entryLabel.emoji)
                    .font(.system(size: 40))
                
            } else {
                Text("No Enough Data")
                    .opacity(0.5)
            }
            
            Spacer()
            if let entry = entry {
                DollarAmount(amount: entry.amount)
                    .opacity(0.4)
            }
        }
        .padding()
        
    }
}

struct TotalAmountThisWeek: View {
    var labelType: LabelType
    var color: Color {
        ModelData.makeColor(type: labelType)
    }
    var amount: Double
    
    var body: some View {
        VStack {
            Text(LocalizedStringKey(
                "Total " + "\(labelType.rawValue)"
            ))
            Spacer()
            DollarAmount(amount: amount, fontWeight: .light)
                .font(.system(size: 25))
                .opacity(amount == 0 ? 0.4 : 0.85)
                .foregroundColor(color)
                .fixedSize()
            Spacer()
            
        }
        .padding()
    }
}
