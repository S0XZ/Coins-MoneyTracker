//
//  PiggyBank.swift
//  Coins
//
//  Created by 老人 on 20/08/2022.
//

import SwiftUI

struct PiggyBank: View {
    @EnvironmentObject var modelData: ModelData
    @State var isChangingGoal: Bool = false
    @State var isAddingWantEntry: Bool = false
    
    let verticalPad: CGFloat = 2
    let horizontalPad: CGFloat = 20
    
    let allIHaveTitle: LocalizedStringKey = "All I Have"
    let allIHaveMessage: LocalizedStringKey? = nil
    
    var body: some View {
        let allAmountView = DollarAmount(amount: max(modelData.totalAmount, 0.0), fontWeight: .ultraLight)
            .font(.system(size: 50))
            .opacity(modelData.totalAmount > 0 ? 0.85 : 0.4)
            .fixedSize()
        
        NavigationView {
            ScrollView {
                MySpacer()
                
                //我的所有积蓄。。。
                Group {
                    MyText(text: allIHaveTitle, footnote: allIHaveMessage)
                        .padding(.horizontal, horizontalPad)
                        .padding(.vertical, verticalPad)
                    
                    MyCell()
                        .frame(height: 150)
                        .overlay {
                            BankBackground()
                            .mask{
                                    MyCell().frame(height: 150)
                                }
                            
                            
                            VStack {
                                Spacer()
                                
                                ZStack {
                                    allAmountView
                                        .offset(x: 4, y: 4)
                                        .opacity(0.2)
                                    allAmountView
                                }
                                
                                Spacer()
                                
                                MyButton(text: "Inital Amount: \(modelData.initalAmount.formatted(.currency(code: "USD")))") {
                                    isChangingGoal = true
                                }
                                
                                Spacer()
                            }
                        }
                        .padding(.horizontal, horizontalPad)
                        .padding(.vertical, verticalPad)
                    
                    if modelData.totalAmount < 0 {
                        MyCell()
                            .frame(height: 50)
                            .overlay {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .imageScale(.large)
                                        .foregroundColor(.yellow)
                                    Text("\(abs(modelData.totalAmount).formatted(.currency(code: "USD"))) in debt")
                                        .opacity(0.75)
                                    Spacer()
                                }
                                .padding()
                            }
                            .padding(.horizontal, horizontalPad)
                            .padding(.vertical, verticalPad)
                    }
                    
                    MySpacer()
                }
                
                //我的目标
                Group {
                    MyText(text: "My Goal", footnote: modelData.progressText)
                        .padding(.horizontal, horizontalPad)
                        .padding(.vertical, verticalPad)
                    
                    HStack {
                        MyCell()
                            .frame(height: 150)
                            .overlay {
                                VStack {
                                    Text("This is My Goal").opacity(0.85)
                                    Spacer()
                                    DollarAmount(amount: modelData.goal)
                                        .font(.title2)
                                        .padding(6)
                                        .background {
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke()
                                        }
                                        .opacity(0.7)
                                    Spacer()
                                    
                                    MyButton(text: "Change Goal", isBackgroundOn: false) {
                                        isChangingGoal = true
                                    }
                                }
                                .padding()
                            }
                        
                        Spacer().frame(width: 20)
                        
                        MyCell()
                            .frame(height: 150)
                            .overlay {
                                VStack {
                                    Text("The Progress").opacity(0.85)
                                    Spacer()
                                    ZStack {
                                        Group {
                                            Circle()
                                                .stroke(lineWidth: 8)
                                                .opacity(0.1)
                                            Circle()
                                                .trim(from: 0, to: modelData.progress)
                                                .stroke(lineWidth: 8)
                                                .rotationEffect(.degrees(-90))
                                                .foregroundColor(.accentColor)
                                            Circle()
                                                .trim(from: 0, to: modelData.alreadyProgress)
                                                .stroke(lineWidth: 8)
                                                .rotationEffect(.degrees(-90))
                                                .foregroundColor(Color(uiColor: .systemBackground))
                                                .opacity(0.5)
                                        }
                                        Text("\(Int(modelData.progress*100))%")
                                            .font(.title2)
                                            .bold()
                                            .foregroundColor(.accentColor)
                                    }
                                    .padding(5)
                                    
                                    Spacer()
                                }
                                .padding()
                            }
                            
                    }
                    .padding(.horizontal, horizontalPad)
                    .padding(.vertical, verticalPad)
                    
                    if modelData.totalAmount >= modelData.goal {
                        RoundedRectangle(cornerRadius: 13)
                            .foregroundColor(.accentColor)
                            .frame(height: 50)
                            .overlay {
                                HStack {
                                    Image(systemName: "face.smiling.fill")
                                        .imageScale(.large)
                                        .foregroundColor(.white)
                                    Text("You have reach the goal!")
                                        .bold()
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding()
                            }
                            .padding(.horizontal, horizontalPad)
                            .padding(.vertical, verticalPad)
                    }
                    
                    MySpacer()
                }
                
                Group {
                    MyText(text: "I Want to Buy...", footnote: "Once reach the goal, I will...")
                        .padding(.horizontal, horizontalPad)
                        .padding(.vertical, verticalPad)

                    WantList(isAddingWantEntry: $isAddingWantEntry)
                    .padding(.horizontal, horizontalPad)
                    .padding(.vertical, verticalPad)

                    MySpacer()
                }
                
                
            }
            .sheet(isPresented: $isChangingGoal) {
                ChangeGoal()
            }
            .sheet(isPresented: $isAddingWantEntry) {
                EntryAddView(isWantEntry: true)
            }
            .navigationTitle("My Bank")
            .toolbar {
                ToolbarItem {
                    Button {
                        isChangingGoal.toggle()
                    } label:{
                        Label("Profile", systemImage: "person.crop.circle")
                    }
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}

struct PiggyBank_Previews: PreviewProvider {
    static var previews: some View {
        PiggyBank().environmentObject(ModelData())
            .environmentObject(WantData())
    }
}

struct MyCell: View {
    var color: Color = Color(uiColor: .secondarySystemGroupedBackground)
    
    var body: some View {
        RoundedRectangle(cornerRadius: 13)
            .foregroundColor(color)
    }
}

struct MySpacer: View {
    var height: CGFloat = 20
    
    var body: some View {
        Spacer().frame(height: height)
    }
}


struct MyButton: View {
    var text: LocalizedStringKey
    var isBackgroundOn: Bool = true
    var font: Font = .caption
    
    var action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            if isBackgroundOn {
                HStack {
                    Text(text)
                        .font(font)
                        
                    Image(systemName: "chevron.right.circle.fill")
                        .imageScale(.small)
                }
                .padding(8)
                .foregroundStyle(.secondary)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
            } else {
                HStack {
                    Text(text)
                        .font(font)
                        
                    Image(systemName: "chevron.right.circle.fill")
                        .imageScale(.small)
                }
                .padding(5)
                .foregroundStyle(.secondary)
                .cornerRadius(20)
            }
        }
        .buttonStyle(.plain)
    }
}

struct MyText: View {
    var text: LocalizedStringKey = ""
    var footnote: LocalizedStringKey?
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(text)
                    .font(.title3)
                    .foregroundColor(.accentColor)
                if let footnote = footnote {
                    Text(footnote)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
    }
}

struct DollarAmount: View {
    let amount: Double
    var fractionLength: Int {
        amount > 999 ? 0 : 1
    }
    var fontWeight: Font.Weight = .regular
    var isBold: Bool = false
    
    var body: some View {
        if isBold {
            Text("$" + amount.formatted(.number.precision(.fractionLength(fractionLength))))
                .bold()
                .fontWeight(fontWeight)
                
        } else {
            Text("$" + amount.formatted(.number.precision(.fractionLength(fractionLength))))
                .fontWeight(fontWeight)
        }
    }
}
