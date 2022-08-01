//
//  LabelManagerView.swift
//  MoneyTracker
//
//  Created by 老人 on 23/07/2022.
//

import SwiftUI

struct LabelManagerView: View {
    @EnvironmentObject var modelData: ModelData
    @State var labelType: EntryType = .expense
    @State var isPresent: Bool = false
    
    var labels: [EntryLabel] {
        switch labelType {
        case .expense:
            return modelData.expenseLabels
        case .income:
            return modelData.incomeLabels
        }
    }
    
    func addLabel(with type: EntryType?) {
        isPresent = true
    }
    
    var body: some View {
        List { 
            ForEach(labels) { label in
                NavigationLink {
                    LabelEditView(label: label)
                } label: {
                    HStack {
                        Text(label.emoji)
                        Text(label.text)
                    }
                }
            }
        }
        .pickerStyle(.segmented)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    addLabel(with: labelType)
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
            
            ToolbarItem(placement: .principal) {
                Picker("Type", selection: $labelType) {
                    Image(systemName: "tray.and.arrow.up")
                        .tag(EntryType.expense)
                    Image(systemName: "tray.and.arrow.down")
                        .tag(EntryType.income)
                }
                .frame(width: 140)
                .pickerStyle(.segmented)
            }
        }
        .sheet(isPresented: $isPresent) {
            LabelAddView(isPresent: $isPresent, type: labelType)
        }
        .navigationTitle("Label Manage")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LabelManagerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LabelManagerView()
        }
        .environmentObject(ModelData())
    }
}
