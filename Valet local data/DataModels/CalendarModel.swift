
import Foundation

enum LogType: CaseIterable {
    case poop
    case vomit
    case appetite
    case allergies
    case grooming
    case medication
    // Add other cases as needed, each with potentially an emoji property or similar identifier.
    
    var emoji: String {
        switch self {
            case .poop: return "💩"
            case .vomit: return "🤮"
        case .appetite: return "🍽"
        case .allergies: return "🤧"
        case .medication: return "💊"
            // Define emojis or other identifiers for other log types
            default: return "🔖" // Placeholder for undefined types
        }
    }
}

struct DogLog: Hashable {
    let type: LogType
    let date: Date
    let description: String

    init(type: LogType, date: Date, description: String) {
        self.type = type
        self.date = date
        self.description = description
    }
}

enum CategoryType: String, CaseIterable, Identifiable {
    case category1, category2 // Replace these with your actual categories
    var id: Self { self }
}

