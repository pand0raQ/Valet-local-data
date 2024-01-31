
import Foundation

// Define an enum for consistency options
enum Consistency: String, CaseIterable, Codable {
    case regular = "Regular"
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

    // Initializer
    init(lastPoopedDateTime: Date? = nil,
         consist: Consistency = .regular,
         consistComment: String = "",
         color: String = "") {
        self.lastPoopedDateTime = lastPoopedDateTime
        self.consist = consist
        self.consistComment = consistComment
        self.color = color
    }

    func poopedInLast24Hours() -> Bool {
        guard let lastPooped = lastPoopedDateTime else { return false }
        return Calendar.current.isDate(lastPooped, inSameDayAs: Date()) ||
               Calendar.current.isDateInToday(lastPooped)
    }
}

