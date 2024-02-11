

import Foundation

struct DogAppetiteRecord: Codable {
    var foodAmount: String = ""
    var foodBrand: String = ""
    var waterIntake: String = ""
    var lastEatDateTime: Date = Date() // Default to current date

}
