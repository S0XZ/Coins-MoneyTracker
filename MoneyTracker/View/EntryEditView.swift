//
//  EntryEditView.swift
//  MoneyTracker
//
//  Created by 老人 on 23/07/2022.
//

import SwiftUI

struct EntryEditView: View {
    @Environment(\.dismiss) var dismiss: DismissAction
    @EnvironmentObject var modelData: ModelData
    @State var isAlertPre = false
    @FocusState private var focusField: Field?
    @State var alertMessage: LocalizedStringKey = "This is Alert Message."
    @State var labelType: LabelType = .expense
    var entry: Entry
    var entryIndex: Int? {
        modelData.entries.firstIndex(where: { $0.id == entry.id })
    }
    @State var isDeleted: Bool = false
    
    @State var isAddLabel = false
    
    var dateRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .year, value: -2, to: Date())!
        let max = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
        
        return min...max
    }
    
    enum Field: Hashable {
        case amountField
        case noteField
    }
    
    func presentAlert(message: LocalizedStringKey) {
        alertMessage = message
        isAlertPre = true
    }
    
    var body: some View {
        let body =
        List {
            if let index = entryIndex, !isDeleted {
                //Amount Field
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
                    
                    HStack {
                        TextField("Enter...", value: $modelData.entries[index].amount, format: .number.precision(.fractionLength(1)))
                            .font(.system(size: 60, weight: .thin, design: .default))
                            .foregroundColor(entry.color)
                            .keyboardType(.decimalPad)
                            .disableAutocorrection(true)
                            .focused($focusField, equals: .amountField)
                    }
                }
                
                //Label Field
                Section() {
                    DisclosureGroup {
                        LabelPickerView(entryLabel: $modelData.entries[index].entryLabel, labelType: labelType, isAdd: $isAddLabel)
                    } label: {
                        HStack {
                            Image(systemName: "face.dashed")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.accentColor)
                            Text(LocalizedStringKey(
                                labelType.rawValue + " Label"
                            ))
                            Spacer()
                            Text("\(entry.entryLabel.emoji)")
                            Text(LocalizedStringKey(entry.entryLabel.text))
                                .opacity(0.6)
                        }
                        //保证第一个label不为空
                        .onChange(of: self.labelType) { _ in
                            guard let entryLabel = modelData.sortedLabels(type: labelType).first
                            else {return}
                            if self.labelType != entry.entryLabel.labelType {
                                modelData.entries[index].entryLabel = entryLabel.wrappedValue
                            }
                        }
                    }
                    
                }
                
                //Note Field (End)
                Section() {
                    HStack {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.accentColor)
                            .symbolRenderingMode(.hierarchical)
                            TextField("Note...", text: $modelData.entries[index].note)
                                .focused($focusField, equals: .noteField)
                    }
                    DatePicker(selection: $modelData.entries[index].date, in: dateRange,displayedComponents: .date) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.accentColor)
                                .symbolRenderingMode(.hierarchical)
                            Text(LocalizedStringKey(
                                entry.entryDate.rawValue
                            ))
                            
                        }
                    }
                }
            }
            
            Section {
                HStack {
                    Spacer()
                    if !isDeleted, entryIndex != nil {
                        Button(role: .destructive) {
                            presentAlert(message: "Delete Entry?")
                        } label: {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete Entry")
                            }
                        }
                    } else {
                        Text("This Entry is Deleted.")
                            .bold()
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
            }
        }
        .alert("Alert", isPresented: $isAlertPre) {
            Button("Delete", role: .destructive) {
                isDeleted = true
                dismiss()
                modelData.deleteEntry(entry)
            }
        } message: {
            Text(alertMessage)
        }
        .sheet(isPresented: $isAddLabel) {
            LabelAddView(labelType: labelType)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    modelData.favorite(entry)
                } label: {
                    Image(systemName: entry.isFavorite ? "star.fill" : "star")
                }
            }
            
            ToolbarItem(placement: .principal) {
                if entryIndex != nil {
                    TypePicker(labelType: $labelType)
                }
            }
        }
        .navigationTitle(entry.entryLabel.text)
        .navigationBarTitleDisplayMode(.inline)
        
        
        ZStack {
            body
        }
    }
}

struct EntryEditView_Previews: PreviewProvider {
    static var previews: some View {
        EntryEditView(entry: .demoEntries[0])
            .environmentObject(ModelData())
    }
}

struct TypePicker: View {
    @Binding var labelType: LabelType
    
    var body: some View {
        Picker("Type", selection: $labelType) {
            Image(systemName: "tray.and.arrow.up")
                .tag(LabelType.expense)
            Image(systemName: "tray.and.arrow.down")
                .tag(LabelType.income)
        }
        .frame(width: 140)
        .pickerStyle(.segmented)
    }
}
