//
//  wantView.swift
//  Coins
//
//  Created by 老人 on 28/08/2022.
//

import SwiftUI

struct WantList: View {
    @EnvironmentObject var wantData: WantData
    var entries: [Entry] {
        wantData.wantEntries
    }
    @Binding var isAddingWantEntry: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(entries) { entry in
                MyEntryRow(entry: entry,
                           destination: WantEntryEditView(entry: entry)
                )
            }
            
            Button {
                isAddingWantEntry = true
            } label: {
                HStack {
                    AddButton()
                    Text("Add")
                    Spacer()
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 7)
            }
        }
        .background {
            MyCell()
        }
        
    }
}

struct WantList_Previews: PreviewProvider {
    static var previews: some View {
        WantList(isAddingWantEntry: .constant(true))
            .environmentObject(WantData())
    }
}
