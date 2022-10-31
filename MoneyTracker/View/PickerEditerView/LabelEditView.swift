//
//  LabelEditView.swift
//  MoneyTracker
//
//  Created by 老人 on 26/07/2022.
//

import SwiftUI

struct LabelEditView: View {
    var entryLabel: EntryLabel
    @EnvironmentObject var modelData: ModelData
    @Environment(\.dismiss) var dismiss
    @State var isDeleted: Bool = false
    
    var index: Int? {
        return modelData.entryLabels.firstIndex(where: {entryLabel.id == $0.id})
    }
    
    var body: some View {
        List {
            if !isDeleted, let index = index {
                Section {
                    HStack {
                        Text(LocalizedStringKey(modelData.entryLabels[index].labelType.rawValue))
                        Spacer()
                        TypePicker(labelType: $modelData.entryLabels[index].labelType)
                    }
                }
                
                Section("Emoji & Note") {
                    TextField("Emoji...", text: $modelData.entryLabels[index].emoji)
                    TextField("Note...", text: $modelData.entryLabels[index].text)
                }
            }
            
            Section {
                HStack {
                    Spacer()
                    Button(role: .destructive) {
                        isDeleted = true
                        dismiss()
                        modelData.deleteLabel(entryLabel)
                    } label: {
                        Text("Delete Label")
                    }
                    Spacer()
                }
            }
            
        }
        .navigationTitle("\(entryLabel.text)")
    }
}

struct LabelEditView_Previews: PreviewProvider {
    @State static var modelData = ModelData()
    static var previews: some View {
        LabelEditView(entryLabel: EntryLabel.demoLabels[0])
            .environmentObject(modelData)
    }
}
