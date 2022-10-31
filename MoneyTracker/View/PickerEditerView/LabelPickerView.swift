//
//  LabelPickerView.swift
//  MoneyTracker
//
//  Created by 老人 on 19/07/2022.
//

import SwiftUI

struct LabelPickerView: View {
    @Binding var entryLabel: EntryLabel
    var labelType: LabelType = .expense
    @Binding var isAdd: Bool
    @EnvironmentObject private var modelData: ModelData
    var rows: [GridItem] =
            Array(repeating: .init(.flexible()), count: 2)
    
    var entryLabelGroups: [[EntryLabel]] {
        var entryLabelGroups: [[EntryLabel]] = [[]]
        var pageCount: Int = 0

        for (n,x) in modelData.sortedLabels(type: labelType).enumerated() {
            guard entryLabelGroups.count == pageCount+1 else {return entryLabelGroups}
            entryLabelGroups[pageCount].append(x.wrappedValue)
            if n / (pageCount+1) == 5 {
                pageCount += 1
                entryLabelGroups.append([])
            }
        }
        
        return entryLabelGroups
    }
    
    
    var body: some View {
        PageView(pages: entryLabelGroups.map{GridView(
            entryLabel: $entryLabel,
            entryLabels: $0,
            labelType: labelType,
            showEditButton: $0 == entryLabelGroups.last!
        )}).frame(minHeight: 230)

        return VStack {
            ScrollView(.horizontal) {
                LazyHGrid(rows: rows) {
                    ForEach(modelData.sortedLabels(type: labelType)) { $entryLabel in
                        Button {
                            self.entryLabel = entryLabel
                        } label: {
                            VStack {
                                Text("\(entryLabel.emoji)")
                                    .font(.largeTitle)
                                Text(LocalizedStringKey(entryLabel.text))
                                    .font(.footnote)
                                    .lineLimit(1)
                                    .foregroundStyle(.white)
                                    .colorMultiply(.primary)
                                    .opacity(0.6)
                            }
                            .padding()
                            .overlay {
                                if self.entryLabel.text == entryLabel.text {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(.white)
                                        .colorMultiply(.primary)
                                        .frame(width: 70, height: 70)
                                        .opacity(0.1)
                                }
                            }
                        }
                    }
                    
                    Button {
                        isAdd = true
                    } label: {
                        VStack {
                            AddButton()
                                
                            Text("Add")
                                .font(.footnote)
                                .bold()
                        }
                        .padding()
                    }
                    
                    NavigationLink {
                        LabelManagerView(labelType: labelType)
                    } label: {
                        VStack {
                            EditButton()
                                
                            Text("Edit")
                                .font(.footnote)
                                .bold()
                        }
                        .padding()
                    }
                }
                .frame(minHeight: 200)
                
            }
            .overlay() {
                HStack {
                    Spacer()
                    Rectangle()
                        .frame(width: 15)
                        .foregroundStyle(LinearGradient(
                            colors: [.background(), .background().opacity(0)], startPoint: .trailing, endPoint: .leading
                        ))
                }
            }
        }
    }
}

extension Color {
    static func background() -> Color {
        return Color(uiColor: .secondarySystemGroupedBackground)
    }
}

struct GridView: View {
    @Binding var entryLabel: EntryLabel
    var rows: [GridItem] =
            Array(repeating: .init(.flexible()), count: 2)
    var entryLabels: [EntryLabel]
    var labelType: LabelType
    var showEditButton: Bool = true
    
    
    var body: some View {
        LazyHGrid(rows: rows) {
            ForEach(entryLabels) { entryLabel in
                Button {
                    self.entryLabel = entryLabel
                } label: {
                    VStack {
                        Text("\(entryLabel.emoji)")
                            .font(.largeTitle)
                        Text(entryLabel.text)
                            .font(.footnote)
                            .lineLimit(1)
                            .foregroundStyle(.white)
                            .colorMultiply(.primary)
                            .opacity(0.6)
                    }
                    .padding()
                    .overlay {
                        if self.entryLabel.text == entryLabel.text {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.white)
                                .colorMultiply(.primary)
                                .frame(width: 70, height: 70)
                                .opacity(0.1)
                        }
                    }
                }
            }
            
            if showEditButton{
                NavigationLink {
                    LabelManagerView(labelType: labelType)
                } label: {
                    VStack {
                        EditButton()
                            
                        Text("Edit")
                            .font(.footnote)
                            .bold()
                    }
                    .padding()
                }
            }
        }
    }
}

struct LabelPickerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                LabelPickerView(entryLabel: .constant(.demoLabels[0]), isAdd: .constant(false))
                    .environmentObject(ModelData())
            }
        }
    }
}

struct AddButton: View {
    var body: some View {
        Image(systemName: "plus")
            .resizable()
            .scaledToFit()
            .frame(width: 20)
            .padding(10)
            .overlay {
                Circle().opacity(0.1)
            }
    }
}

struct EditButton: View {
    var body: some View {
        Image(systemName: "gearshape")
            .resizable()
            .scaledToFit()
            .frame(width: 20)
            .padding(10)
            .overlay {
                Circle().opacity(0.1)
            }
    }
}
