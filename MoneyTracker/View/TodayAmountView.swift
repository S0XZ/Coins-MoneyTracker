//
//  TodayAmountView.swift
//  MoneyTracker
//
//  Created by 老人 on 23/07/2022.
//

import SwiftUI
import WidgetKit

struct TodayAmountView: View {
    var amount: Double
    var labelType: LabelType
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: ModelData.makeIcon(with: labelType))
                Text("Today")
                Text(LocalizedStringKey(labelType.rawValue))
            }
            
            .foregroundStyle(.secondary)
            
            Divider().frame(width: 60)
            
            HStack {
                DollarAmount(amount: amount, fontWeight: .thin)
                .font(.system(size: 50))
                .fixedSize()
                .foregroundColor(ModelData.makeColor(type: labelType))
                .opacity(amount == 0 ? 0.4 : 0.85)
            }
        }
        .padding()
        .onAppear {
            modelData.reloadWidget()
        }
    }
    
    
}

struct TodayAmountView_Previews: PreviewProvider {
    static var previews: some View {
        TodayAmountView(amount: 20, labelType: .expense)
            .environmentObject(ModelData())
    }
}
