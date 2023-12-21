//
//  localDataStorage.swift
//  Valet local data
//
//  Created by Анастасия Степаносова on 21.12.2023.
//

import Foundation

struct DogHealthRecord: Codable {
    var lastPoopedDateTime: Date
    var consist: String
    var consistComment: String
    var color: String
    var colorComment: String
    var eatenAmountPerHour: String
    var brandName: String
    var waterAmount: String
}

// You can also include any local data storage related functions here in the future.
