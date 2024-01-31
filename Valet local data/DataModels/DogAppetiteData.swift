//
//  DogAppetiteData.swift
//  Valet local data
//
//  Created by Анастасия Степаносова on 24.12.2023.
//

import Foundation

struct DogAppetiteRecord: Codable {
    var foodAmount: String = ""
    var foodBrand: String = ""
    var waterIntake: String = ""
    var lastEatDateTime: Date = Date() // Default to current date

}
