
import Foundation

enum LogType: Hashable {
    case poop, vomit, appetite, medication, allergies, grooming 
    // Add more log types if needed
}

struct DogLog: Hashable {
    let type: LogType
    let date: Date
    let description: String

    // Add more properties if needed
}
