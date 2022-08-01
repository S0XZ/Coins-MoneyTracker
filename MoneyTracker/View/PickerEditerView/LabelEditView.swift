//
//  LabelEditView.swift
//  MoneyTracker
//
//  Created by 老人 on 26/07/2022.
//

import SwiftUI

struct LabelEditView: View {
    var label: EntryLabel
    @EnvironmentObject var modelData: ModelData
    
    private var labelIndex: Int {
        guard let index: Int = modelData.labels.firstIndex(where: {
            $0.id == label.id
        }) else {return 2}
        return index
    }
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text("Type")
                    Spacer()
                    Picker("Type", selection: $modelData.labels[labelIndex].type) {
                        Image(systemName: "tray.and.arrow.up")
                            .tag(EntryType.expense)
                        Image(systemName: "tray.and.arrow.down")
                            .tag(EntryType.income)
                    }
                    .frame(width: 140)
                    .pickerStyle(.segmented)
                }
            }
            
            HStack {
                Text("Emoji")
                Divider()
                Spacer()
                TextField("Emoji...", text: $modelData.labels[labelIndex].emoji)
            }
              
            
            HStack {
                Text("Note")
                Divider()
                TextField("Note...", text: $modelData.labels[labelIndex].text)
            }
            
        }
        .navigationTitle(label.text)
    }
}

struct LabelEditView_Previews: PreviewProvider {
    @State static var modelData = ModelData()
    static var previews: some View {
        LabelEditView(label: modelData.labels[0])
            .environmentObject(modelData)
    }
}
