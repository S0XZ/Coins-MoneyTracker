//
//  LabelManagerView.swift
//  MoneyTracker
//
//  Created by 老人 on 23/07/2022.
//

import SwiftUI

struct LabelManagerView: View {
    @EnvironmentObject var modelData: ModelData
    @State var labelType: LabelType = .expense
    @State var isPresent: Bool = false
    @State var isAlertRestoreLabels = false
    
    func addLabel(with type: LabelType?) {
        isPresent = true
    }
    
    var body: some View {
        List { 
            ForEach(modelData.sortedLabels(type: labelType)) { $entryLabel in
                NavigationLink {
                    LabelEditView(entryLabel: entryLabel)
                } label: {
                    HStack {
                        Text(entryLabel.emoji)
                        Text(entryLabel.text)
                    }
                }
                .swipeActions {
                    Button(role: .destructive) {
                        modelData.deleteLabel(entryLabel)
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
            
            Section {
                Button(role: .destructive) {
                   isAlertRestoreLabels = true
                } label: {
                    HStack {
                        Spacer()
                        Image(systemName: "arrow.clockwise")
                        Text("Restore All Labels")
                        Spacer()
                    }
                }
            }
        }
        .alert("Restore All Labels", isPresented: $isAlertRestoreLabels){
            Button(role: .destructive) {
                modelData.entryLabels = EntryLabel.demoLabels
            } label: {
                HStack {
                    Text("Restore")
                }
            }
        } message: {
            
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
                TypePicker(labelType: $labelType)
            }
        }
        .sheet(isPresented: $isPresent) {
            LabelAddView(labelType: labelType)
        }
        .navigationTitle("Label Manage")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.slow(), value: labelType)
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
