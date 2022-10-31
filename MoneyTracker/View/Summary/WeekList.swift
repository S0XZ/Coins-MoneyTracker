//
//  MyList.swift
//  Coins
//
//  Created by 老人 on 29/08/2022.
//

import SwiftUI

struct WeekList: View {
    @EnvironmentObject var modelData: ModelData
    var labelType: LabelType = .expense
    var weekIndex: Int = 0
    var entries: [Entry] {
        return modelData.entriesByWeek(type: labelType, week: weekIndex)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(entries) { entry in
                MyEntryRow(entry: entry,
                           destination: EntryEditView(labelType: entry.entryLabel.labelType, entry: entry)
                           )
            }
        }
        .background {
            MyCell()
        }
    }
}

struct MyEntryRow<Destination: View>: View {
    var entry: Entry
    let destination: Destination
    
    var body: some View {
        NavigationLink {
            destination
        } label: {
            HStack {
                EntryRowView(entry: entry)
                Image(systemName: "chevron.right")
                    .imageScale(.small)
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 7)
            .background(Color(UIColor.secondarySystemGroupedBackground).opacity(0.01))
        }
        .buttonStyle(.plain)
        
        Divider()
            .padding(.leading, 60)
    }
}

struct WeekList_Previews: PreviewProvider {
    static var previews: some View {
        WeekList().environmentObject(ModelData())
    }
}
