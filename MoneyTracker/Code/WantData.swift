//
//  IWantToBuy.swift
//  Coins
//
//  Created by 老人 on 28/08/2022.
//

import Foundation
import SwiftUI

final class WantData: ObservableObject {
    @Published var wantEntries: [Entry] = [Entry(entryLabel: .demoLabels[11], amount: 999, note: "My Dream", date: .now, isFavorite: false)] {
        didSet {
            save()
            print("WantEntries Saved.")
        }
    }
    
    @AppStorage("wantEntryData") var wantEntryData: Data = Data()
    
    func save() {
        guard let wantEntryData = try? JSONEncoder().encode(self.wantEntries)
        else {
            return
        }
        
        self.wantEntryData = wantEntryData
    }
    
    func fetch() {
        guard let decodedEntry = try? JSONDecoder().decode([Entry].self, from: self.wantEntryData)
        else {return}
        self.wantEntries = decodedEntry
        
    }
    
    init() {
        print("Inited.")
        fetch()
        print("Init Finished.")
    }
    
    func deleteEntry(_ entry: Entry) {
        withAnimation(.easeOut) {
            wantEntries.removeAll { $0.id == entry.id }
        }
    }
}
