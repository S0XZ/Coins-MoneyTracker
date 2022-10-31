//
//  DailyThreshold.swift
//  Coins
//
//  Created by 老人 on 9/20/22.
//

import SwiftUI

struct DailyThreshold: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var preferData: PreferData
    var limit: Double {
        preferData.dailyLimit
    }
    var amount: Double {
        modelData.amountInDay(day: Date.now).0
    }
    var progress: Double {
        min(max(amount, 0)/limit, 1)
    }
    let limitRange: [Int] = {
        var range: [Int] = []
        for i in 50...2000 {
            if i%50 == 0 {
                range.append(i)
            }
        }
        return range
    }()
    
    var body: some View {
        NavigationLink {
            List {
                Section {
                    DisclosureGroup {
                        Picker(selection: $preferData.dailyLimit) {
                            ForEach(limitRange, id: \.self) { i in
                                Text(i.description)
                                    .tag(Double(i))
                            }
                        } label: {
                            
                        }
                        .pickerStyle(.wheel)
                    } label: {
                        HStack {
                            Image(systemName: "ruler")
                            Text("Daily Spend Limit")
                            Spacer()
                            Text(limit.description)
                        }
                    }
                } footer: {
                    Text("You can disable Daily Limit in Settings.")
                }
            }
            .navigationTitle("Daily Limit")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.grouped)
        } label: {
            HStack {
                if amount/limit > 1 {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                        .foregroundColor(.accentColor)
                        .padding(6)
                } else {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 5)
                            .opacity(0.1)
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(lineWidth: 5)
                            .rotationEffect(.degrees(-90))
                            .foregroundColor(.accentColor)
                    }
                    .aspectRatio(contentMode: .fit)
                    .padding(6)
                }
                
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(Int(progress*100))%")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.accentColor)
                    }
                    
                    if amount <= 0 {
                        Text("You haven't spent today.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else if amount/limit > 1{
                        Text("**$\((amount - limit).formatted(.number.precision(.fractionLength(1))))** over the limit!")
                            .font(.subheadline)
                            .opacity(0.7)
                    } else {
                        Text("Left **$\((limit - amount).formatted(.number.precision(.fractionLength(1))))** to spend today.")
                            .font(.subheadline)
                            .opacity(0.7)
                    }
                    
                }
                Spacer()
            }//end of hstack
        }
    }
}

struct DailyThreshold_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                DailyThreshold()
                    .environmentObject(ModelData())
                    .environmentObject(PreferData())
                    .frame(height: 50)
            }
        }
    }
}
