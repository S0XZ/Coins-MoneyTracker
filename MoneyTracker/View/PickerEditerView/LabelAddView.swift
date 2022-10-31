//
//  LabelAddView.swift
//  MoneyTracker
//
//  Created by 老人 on 27/07/2022.
//

import SwiftUI

import SwiftUI

struct LabelAddView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.dismiss) var dismiss
    @State var isAlertPre: Bool = false
    @State var message: LocalizedStringKey = ""
    
    @State var labelType: LabelType = .expense
    @State var emoji: String = ""
    @State var text: String = ""
    
    func addLabel() {
        guard !emoji.isEmpty, !text.isEmpty else {
            presentAlert(with: "Please fill all fields.")
            return
        }
        let label = EntryLabel(emoji: emoji, text: text, labelType: labelType)
        modelData.addLabel(with: label)
        dismiss()
    }
    
    func presentAlert(with message: LocalizedStringKey) {
        self.message = message
        isAlertPre = true
    }
    
    var body: some View {
        NavigationView {
            List {
                Section() {
                    HStack {
                        Text(LocalizedStringKey(
                            labelType.rawValue
                        ))
                        Spacer()
                        TypePicker(labelType: $labelType)
                    }
                }
                
                Section("Emoji & Note") {
                    TextField("Emoji...", text: $emoji)
                    TextField("Note...", text: $text)
                }
            }
            .navigationTitle(LocalizedStringKey (
                text.isEmpty ? "Add Label": text
            ))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        addLabel()
                    }
                }
            }
            .alert("Error", isPresented: $isAlertPre) {
                
            } message: {
                Text(message)
            }
        }
    }
}

struct LabelAddView_Previews: PreviewProvider {
    @State static var modelData = ModelData()
    static var previews: some View {
        LabelAddView()
            .environmentObject(modelData)
    }
}
