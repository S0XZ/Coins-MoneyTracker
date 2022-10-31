//
//  WelcomeScreen.swift
//  Coins
//
//  Created by 老人 on 06/08/2022.
//

import SwiftUI

struct WelcomeScreen: View {
    @Binding var isPre: Bool
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        NavigationView {
            ScrollView {
                Image("CoinWelcome")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                
                Text("Welcome to ***Coins***")
                    .font(.largeTitle)
                    .opacity(0.7)
                
                WelcomeRow(imageName: "dollarsign.circle", text: "Expense & Icome", message: "Manage Your Entries")
                
                WelcomeRow(imageName: "chart.bar", text: "Recent Summary", message: "Automaticly Analyze Data")
                
                WelcomeRow(imageName: "face.dashed", text: "Labels", message: "Use Emoji Labels to Tag Entries")
                
                Spacer()
                
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPre = false
                        modelData.isWel = true
                    } label: {
                        
                        HStack {
                            Text("Continue")
                            Image(systemName: "chevron.right")
                                .imageScale(.small)
                        }
                    }
                }
            }
        }
        
    }
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen(isPre: .constant(true))
            .environmentObject(ModelData())
    }
}

struct WelcomeRow: View {
    let imageName: String
    let text: LocalizedStringKey
    let message: LocalizedStringKey
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .symbolRenderingMode(.hierarchical)
                .resizable()
                .scaledToFit()
                .foregroundColor(.accentColor)
                .frame(width: 40)
                .padding()
            
            Divider()
            
            VStack(alignment: .leading) {
                Text(text)
                    .font(.title2)
                    .fontWeight(.light)
                
                Text(message)
                    .fontWeight(.light)
                    .opacity(0.6)
            }
            Spacer()
        }
        .padding()
        .opacity(0.8)
    }
}
