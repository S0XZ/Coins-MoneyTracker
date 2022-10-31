//
//  BankBackground.swift
//  Coins
//
//  Created by 老人 on 28/08/2022.
//

import SwiftUI

struct BankBackground: View {
    var columns: [GridItem] =
            Array(repeating: .init(.flexible()), count: 6)
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(0..<18) { i in
                Image(systemName: i%2 == 0 ? "dollarsign.circle" : "tray.and.arrow.down")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .rotationEffect(.degrees(-30))
                    .padding(6)
                    .opacity(0.08)
            }
        }
    }
}

struct BankBackground_Previews: PreviewProvider {
    static var previews: some View {
        BankBackground()
    }
}
