//
//  EntryEditView.swift
//  MoneyTracker
//
//  Created by 老人 on 23/07/2022.
//

import SwiftUI

struct EntryEditView: View {
    @EnvironmentObject var modelData: ModelData
    @State var isAlertPre = false
    @FocusState private var focusField: Field?
    @State var alertMessage: String = "Error"
    var entry: Entry
    var entryIndex: Int {
        modelData.entries.firstIndex(where: { $0.id == entry.id }) ?? 0
    }
    
    var dateRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .year, value: -2, to: Date())!
        let max = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
        
        return min...max
    }
    
    enum Field: Hashable {
        case titleField
        case amountField
        case noteField
    }
    
    func presentAlert(message: String) {
        alertMessage = message
        isAlertPre = true
    }
    
    func removeEntry() {
        modelData.entries.remove(at: entryIndex)
    }
    
    var body: some View {
        
        List {
            Section {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "dollarsign.circle")
                        Text("Amount")
                        Spacer()
                    }
                }
                
                HStack {
                    TextField("Enter...", value: $modelData.entries[entryIndex].amount, format: .currency(code: "USD"))
                        .font(.system(size: 60, weight: .thin, design: .default))
                        .foregroundColor(modelData.entries[entryIndex].color)
                        .keyboardType(.decimalPad)
                        .disableAutocorrection(true)
                        .focused($focusField, equals: .amountField)
                }
            }
            
            Section {
                LabelPickerView(label: $modelData.entries[entryIndex].label, labelType: entry.label.type)
                    
                DatePicker(selection: $modelData.entries[entryIndex].date, in: dateRange,displayedComponents: .date) {
                    HStack {
                        Image(systemName: "calendar")
                        Text("Date")
                    }
                }
            }
            
            Section {
                HStack {
                    Image(systemName: "pencil")
                        TextField("Note...", text: $modelData.entries[entryIndex].note)
                            .focused($focusField, equals: .noteField)
                }
            }
            
            Section {
                HStack {
                    Spacer()
                    Button("Remove Entry", role: .destructive) {
                        presentAlert(message: "Remove Entry?")
                    }
                    Spacer()
                }
            }
        }
        .onAppear {
            focusField = .titleField
        }
        .alert("Alert", isPresented: $isAlertPre) {
            Button("Remove", role: .destructive) {
                removeEntry()
            }
            
        } message: {
            Text(alertMessage)
        }
        .navigationTitle("\(modelData.entries[entryIndex].label.text)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EntryEditView_Previews: PreviewProvider {
    static var previews: some View {
        EntryEditView(entry: ModelData().entries[0])
            .environmentObject(ModelData())
    }
}
