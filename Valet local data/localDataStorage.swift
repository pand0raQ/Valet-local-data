//
//  localDataStorage.swift
//  Valet local data
//
//  Created by Анастасия Степаносова on 21.12.2023.
//

import Foundation

// Define an enum for consistency options
enum Consistency: String, CaseIterable, Codable {
    case regular = "Regular"
    case constipation = "Constipation"
    case droopy = "Droopy"
    case diarrhoea = "Diarrhoea"
}

// DogHealthRecord struct
struct DogHealthRecord: Codable {
    var lastPoopedDateTime: Date
    var consist: Consistency
    var consistComment: String
    var color: String
    var colorComment: String
}
