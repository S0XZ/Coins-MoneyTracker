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
    @Binding var isPresent: Bool
    @State var isAlertPre: Bool = false
    @State var message: String = ""
    
    @State var type: EntryType = .expense
    @State var emoji: String = ""
    @State var text: String = ""
    
    func addLabel() {
        guard !emoji.isEmpty, !text.isEmpty else {
            presentAlert(with: "Please fill all fields.")
            return
        }
        let label = EntryLabel(emoji: emoji, text: text, type: type)
        modelData.addLabel(with: label)
        isPresent = false
    }
    
    func presentAlert(with message: String) {
        self.message = message
        isAlertPre = true
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Text("Type")
                        Spacer()
                        Picker("Type", selection: $type) {
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
                    TextField("Emoji...", text: $emoji)
                }
                  
                
                HStack {
                    Text("Note")
                    Divider()
                    TextField("Note...", text: $text)
                }
                
            }
            .navigationTitle(text.isEmpty ? "Add Label": text)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                       isPresent = false
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
        LabelAddView(isPresent: .constant(true))
            .environmentObject(modelData)
    }
}
