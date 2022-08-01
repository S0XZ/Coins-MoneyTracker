//
//  LabelPickerView.swift
//  MoneyTracker
//
//  Created by 老人 on 19/07/2022.
//

import SwiftUI

struct LabelPickerView: View {
    @Binding var label: EntryLabel
    @State var labelType: EntryType = .expense
    @EnvironmentObject var modelData: ModelData
    var labels: [EntryLabel] {
        switch labelType {
        case .expense:
            return modelData.expenseLabels
        case .income:
            return modelData.incomeLabels
        }
    }
    var columns: [GridItem] =
            Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        let typePicker =
        Picker("Type", selection: $labelType) {
            Image(systemName: "tray.and.arrow.up")
                .tag(EntryType.expense)
            Image(systemName: "tray.and.arrow.down")
                .tag(EntryType.income)
        }
        .frame(width: 140)
        .pickerStyle(.segmented)
        
        return VStack {
            typePicker

            
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(labels) { label in
                        Button {
                            self.label = label
                        } label: {
                            VStack {
                                Text("\(label.emoji)")
                                    .font(.largeTitle)
                                Text(label.text)
                                    
                                    .font(.footnote)
                                    .bold()
                                    .lineLimit(1)
                                    .colorMultiply(.primary)
                                    .opacity(0.6)
                            }
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .colorMultiply(.primary)
                                .frame(width: 70, height: 70)
                                .opacity(self.label == label ? 0.1 : 0)
                            )
                        }
                    }
                }
            }
        }
    }
}

struct LabelPickerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                LabelPickerView(label: .constant(.demoLabels[0]))
                    .environmentObject(ModelData())
            }
        }
    }
}
