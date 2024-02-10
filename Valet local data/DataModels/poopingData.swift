

import Foundation

// Define an enum for consistency options
enum Consistency: String, CaseIterable, Codable {
    case constipation = "Constipation"
    case droopy = "Droopy"
    case diarrhoea = "Diarrhoea"
}

// PoopingData struct
struct PoopingData: Codable {
    let id: UUID = UUID()
    var lastPoopedDateTime: Date?
    var consist: Consistency
    var consistComment: String
    var color: String
    var isDetailed: Bool // Add this line to include the isDetailed property

    // Initializer
    init(lastPoopedDateTime: Date? = nil,
         consist: Consistency = .constipation,
         consistComment: String = "",
         color: String = "",
         isDetailed: Bool = false) { // Modify this line to include the isDetailed parameter
        self.lastPoopedDateTime = lastPoopedDateTime
        self.consist = consist
        self.consistComment = consistComment
        self.color = color
        self.isDetailed = isDetailed // Add this line to initialize the isDetailed property
    }

    func poopedInLast24Hours() -> Bool {
        guard let lastPooped = lastPoopedDateTime else { return false }
        return Calendar.current.isDate(lastPooped, inSameDayAs: Date()) ||
               Calendar.current.isDateInToday(lastPooped)
    }
}
