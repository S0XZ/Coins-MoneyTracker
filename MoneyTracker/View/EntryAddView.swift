//
//  EntryEditView.swift
//  MoneyTracker
//
//  Created by 老人 on 19/07/2022.
//

import SwiftUI

struct EntryAddView: View {
    @EnvironmentObject var modelData: ModelData
    @Binding var isPresent: Bool
    @State var label: EntryLabel = .demoLabels[0]
    @State var amount: Double?
    @State var note: String = ""
    @State var entryType: EntryType = .expense
    @State var date: Date = Date()
    @State var isAlertPre = false
    @FocusState private var focusField: Field?
    @State var alertMessage: String = "Error"
    
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
    
    func finishAdd() {
        guard let amount = amount else {
            presentAlert(message: "Amount is Required.")
            return
        }

        let entry = Entry(label: label, amount: amount, note: note, date: date)
        modelData.addEntry(with: entry)

        isPresent = false
    }
    
    func presentAlert(message: String) {
        alertMessage = message
        isAlertPre = true
    }
    
    func makeColor(type: EntryType) -> Color {
        var color: Color {
            switch type {
            case .expense:
                return .primary
            case .income:
                return .green
            }
        }
        return color
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "dollarsign.circle")
                            Text("Amount")
                            Spacer()
                        }
                                       
                    }
                    
                    TextField("Enter...", value: $amount, format: .currency(code: "USD"))
                        .font(.system(size: 60, weight: .thin, design: .default))
                        .foregroundColor(makeColor(type: label.type))
                        .keyboardType(.decimalPad)
                        .disableAutocorrection(true)
                        .focused($focusField, equals: .amountField)
                        .onSubmit {
                            finishAdd()
                        }
                }
                
                Section {
                    LabelPickerView(label: $label)
                        
                    DatePicker(selection: $date, in: dateRange,displayedComponents: .date) {
                        HStack {
                            Image(systemName: "calendar")
                            Text("Date")
                        }
                    }
                }
                
                Section {
                    HStack {
                        Image(systemName: "pencil")
                        
                        TextField("Note...", text: $note)
                            .focused($focusField, equals: .noteField)
                    }
                }
            }
            .onAppear {
                focusField = .titleField
            }
            .alert("Error", isPresented: $isAlertPre) {
                
            } message: {
                Text(alertMessage)
            }
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresent = false
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        finishAdd()
                    }
                }
            }
        }
    }
}

struct EntryAddView_Previews: PreviewProvider {
    static var previews: some View {
        EntryAddView(isPresent: .constant(false))
            .environmentObject(ModelData())
    }
}
