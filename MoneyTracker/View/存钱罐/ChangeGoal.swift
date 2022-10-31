//
//  ChangeGoal.swift
//  Coins
//
//  Created by 老人 on 20/08/2022.
//

import SwiftUI

struct ChangeGoal: View {
    let initalAmountRange: [Int] = {
        var range: [Int] = []
        for i in 0...10000 {
            if i%100 == 0 {
                range.append(i)
            }
        }
        return range
    }()
    
    let goalRange: [Int] = {
        var range: [Int] = []
        for i in 0...10000 {
            if i%100 == 0 {
                range.append(i)
            }
        }
        return range
    }()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var preferData: PreferData
    
    var body: some View {
        NavigationView {
            List {
                Section("Goal") {
                    DisclosureGroup {
                        HStack {
                            Picker("Goal", selection: $modelData.goal) {
                                ForEach(goalRange, id: \.self) { i in
                                    Text(i.description)
                                        .tag(Double(i))
                                }
                            }
                            .pickerStyle(.wheel)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "lightbulb")
                                .foregroundColor(.accentColor)
                            
                            Text("My goal is...")
                            Spacer()
                            Text("$" + modelData.goal.description)
                                .bold()
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                Section("Inital Amount") {
                    DisclosureGroup {
                        Picker("Inital Amount", selection: $modelData.initalAmount) {
                            ForEach(initalAmountRange, id: \.self) { i in
                                Text(i.description)
                                    .tag(Double(i))
                            }
                        }
                        .pickerStyle(.wheel)
                    } label: {
                        HStack {
                            Image(systemName: "shippingbox")
                                .foregroundColor(.accentColor)
                            Text("I already have...")
                            Spacer()
                            Text("$" + modelData.initalAmount.description)
                                .bold()
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .toolbar {
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .accentColor(preferData.preferColor)
            .listStyle(.grouped)
            .navigationTitle("Change Goal")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ChangeGoal_Previews: PreviewProvider {
    static var previews: some View {
        ChangeGoal()
            .environmentObject(PreferData())
            .environmentObject(ModelData())
    }
}
