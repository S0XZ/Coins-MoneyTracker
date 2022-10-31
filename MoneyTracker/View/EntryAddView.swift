//
//  EntryEditView.swift
//  MoneyTracker
//
//  Created by 老人 on 19/07/2022.
//

import SwiftUI

struct EntryAddView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var preferData: PreferData
    @EnvironmentObject var wantData: WantData
    @Environment(\.dismiss) var dismiss: DismissAction
    @State var entryLabel: EntryLabel = .demoLabels[0]
    @State var amount: Double?
    @State var note: String = ""
    @State var labelType: LabelType = .expense
    @State var date: Date = Date()
    @State var isFavorite: Bool = false
    @State var isAlertPre = false
    @FocusState private var focusField: Field?
    @State var alertMessage: LocalizedStringKey = "Error"
    
    @State var isAddLabel = false
    
    var isWantEntry: Bool = false
    
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

        let entry = Entry(entryLabel: entryLabel, amount: amount, note: note, date: date, isFavorite: isFavorite)
        if isWantEntry {
            wantData.wantEntries.append(entry)
        } else {
            modelData.addEntry(with: entry)
        }
        

        dismiss()
    }
    
    func presentAlert(message: LocalizedStringKey) {
        alertMessage = message
        isAlertPre = true
    }
    
    var body: some View {
        NavigationView {
            List {
                Section() {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "dollarsign.circle")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.accentColor)
                            Text("Amount")
                            Spacer()
                        }
                                       
                    }
                    
                    TextField("Enter...", value: $amount, format: .number.precision(.fractionLength(1)))
                        .font(.system(size: 60, weight: .thin, design: .default))
                        .foregroundColor(ModelData.makeColor(type: entryLabel.labelType))
                        .keyboardType(.decimalPad)
                        .disableAutocorrection(true)
                        .focused($focusField, equals: .amountField)
                        .onSubmit {
                            finishAdd()
                        }
                }
                
                Section {
                    LabelPickerView(entryLabel: $entryLabel, labelType: labelType, isAdd: $isAddLabel)
                    //保证第一个label不为空
                    .onChange(of: self.labelType) { _ in
                        guard let label = modelData.sortedLabels(type: labelType).first
                        else {return}
                        self.entryLabel = label.wrappedValue
                    }
                } header: {
                    Text(LocalizedStringKey(
                        labelType.rawValue + " Label"
                    ))
                }
                
                Section() {
                    HStack {
                        Image(systemName: "square.and.pencil")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.accentColor)
                        TextField("Note...", text: $note)
                            .focused($focusField, equals: .noteField)
                    }
                    
                    if !isWantEntry {
                        DatePicker(selection: $date, in: dateRange,displayedComponents: .date) {
                            HStack {
                                Image(systemName: "calendar")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.accentColor)
                                Text("Date")
                            }
                        }
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
            .navigationTitle(entryLabel.text)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isAddLabel) {
                LabelAddView(labelType: labelType)
            }
            .accentColor(preferData.preferColor)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if !isWantEntry {
                        Button {
                            isFavorite.toggle()
                        } label: {
                            Image(systemName: isFavorite ? "star.fill" : "star")
                        }
                    }
                    Button("Add") {
                        finishAdd()
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    TypePicker(labelType: $labelType)
                }
            }
        }
    }
}

struct EntryAddView_Previews: PreviewProvider {
    static var previews: some View {
        EntryAddView()
            .environmentObject(PreferData())
            .environmentObject(ModelData())
            .environmentObject(WantData())
    }
}
