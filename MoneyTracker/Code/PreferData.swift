//
//  PreferData.swift
//  Coins
//
//  Created by 老人 on 14/09/2022.
//

import Foundation
import SwiftUI
import WidgetKit

final class PreferData: ObservableObject {
    //Color
    @Published var preferColor: Color = .mint {
        didSet {
            WidgetCenter.shared.reloadTimelines(ofKind: "Coins_Widget")
            save()
        }
    }
    @AppStorage("colorString", store: UserDefaults(suiteName: "group.older.coins")) var colorString: String = "mint"
    let preferColors: [Color] = [.mint, .red, .brown, .blue, .indigo, .purple, .orange, .pink, .green]
    var preferColorDescriptions: [String] {
        preferColors.map {$0.description}
    }
    
    //Grouped by date
    @AppStorage("isGroupedByDate") var isGroupedByDate: Bool = true
    @AppStorage("dailyLimit") var dailyLimit: Double = 50
    @AppStorage("isDailyLimitEnbled") var isDailyLimitEnbled = true
    
    func save() {
        colorString = preferColor.description
    }
    
    func fetch() {
        if let color = stringToColor(colorString: colorString) {
            preferColor = color
        }
    }
    
    func stringToColor(colorString: String) -> Color? {
        let color = preferColors.first {$0.description == colorString}
        return color
    }
    
    init() {
        fetch()
        
    }
}
