//
//  CardModel.swift
//  Valet local data
//
//  Created by Анастасия Степаносова on 30.12.2023.
//

import Foundation
import Foundation

struct CardModel: Identifiable {
    let id = UUID()
    var title: String
    var detail: String
    var isExpanded: Bool

    static let sampleData: [CardModel] = [
        CardModel(title: "Card 1", detail: "Detail 1", isExpanded: false),
        CardModel(title: "Card 2", detail: "Detail 2", isExpanded: false)
        // Add more sample data
    ]
}

