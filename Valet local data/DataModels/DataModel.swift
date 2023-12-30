//
//  DataModel.swift
//  Valet local data
//
//  Created by Анастасия Степаносова on 30.12.2023.
//


import Foundation

struct CardData: Identifiable {
    var id = UUID()
    var title: String
    var details: String
    var isExpanded: Bool = false
    // Add other data properties as needed
}

class DataModel: ObservableObject {
    @Published var cards: [CardData] = [
        // Initialize with some data
    ]

    func addEntry(title: String, details: String) {
        let newEntry = CardData(title: title, details: details)
        cards.insert(newEntry, at: 0) // Add at the beginning for 'recent' data
    }
}
