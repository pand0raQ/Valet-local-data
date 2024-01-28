

import Foundation

struct GroomingActivity: Identifiable, Codable {
    let id: UUID
    var activityName: String
    var frequencyInWeeks: Int
    var lastCompletedDate: Date?

    var nextDueDate: Date? {
        guard let lastCompleted = lastCompletedDate else { return nil }
        return Calendar.current.date(byAdding: .weekOfYear, value: frequencyInWeeks, to: lastCompleted)
    }

    mutating func markAsCompleted() {
        self.lastCompletedDate = Date() // Sets the current date as the last completed date
    }

    
    // Custom keys for encoding/decoding
    enum CodingKeys: String, CodingKey {
        case id, activityName, frequencyInWeeks, lastCompletedDate
    }
    
    // Custom init from decoder for handling Date
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        activityName = try container.decode(String.self, forKey: .activityName)
        frequencyInWeeks = try container.decode(Int.self, forKey: .frequencyInWeeks)
        lastCompletedDate = try container.decodeIfPresent(Date.self, forKey: .lastCompletedDate)
    }

    // Custom encode function for handling Date
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(activityName, forKey: .activityName)
        try container.encode(frequencyInWeeks, forKey: .frequencyInWeeks)
        try container.encodeIfPresent(lastCompletedDate, forKey: .lastCompletedDate)
    }

    // Default initializer
    init(id: UUID = UUID(), activityName: String, frequencyInWeeks: Int, lastCompletedDate: Date? = nil) {
        self.id = id
        self.activityName = activityName
        self.frequencyInWeeks = frequencyInWeeks
        self.lastCompletedDate = lastCompletedDate
    }
}




class GroomingViewModel: ObservableObject {
    @Published var groomingActivities: [GroomingActivity] {
        didSet {
            print("Activities Updated: \(groomingActivities)")
            
            saveToUserDefaults()
        }
    }
    
    // Computed property to get sorted activities by the next due date
    var sortedGroomingActivities: [GroomingActivity] {
        let sortedActivities = groomingActivities.sorted {
            guard let date1 = $0.nextDueDate, let date2 = $1.nextDueDate else { return false }
            return date1 < date2
        }
        print("Sorted Activities: \(sortedActivities.map { $0.activityName + " - Next Due: \($0.nextDueDate.map { dateFormatter.string(from: $0) } ?? "N/A")" })")
        return sortedActivities
    }
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    init() {
        // Initialize groomingActivities with an empty array
        self.groomingActivities = []
        
        // Then try to load the saved activities from UserDefaults
        if let savedActivities = loadFromUserDefaults() {
            self.groomingActivities = savedActivities
        } else {
            // Default activities if nothing is saved in UserDefaults
            self.groomingActivities = [
                GroomingActivity(activityName: "Ears Cleaning", frequencyInWeeks: 1),
                GroomingActivity(activityName: "Teeth Cleaning", frequencyInWeeks: 2),
                GroomingActivity(activityName: "Paws Clipping", frequencyInWeeks: 4),
                GroomingActivity(activityName: "Bath", frequencyInWeeks: 8),
                GroomingActivity(activityName: "Grooming", frequencyInWeeks: 6),
                
            ]
        }
    }
    
    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(groomingActivities) {
            UserDefaults.standard.set(encoded, forKey: "groomingActivities")
        }
    }
    
    private func loadFromUserDefaults() -> [GroomingActivity]? {
        if let savedActivities = UserDefaults.standard.object(forKey: "groomingActivities") as? Data {
            if let decodedActivities = try? JSONDecoder().decode([GroomingActivity].self, from: savedActivities) {
                return decodedActivities
            }
        }
        return nil
    }
    
    // Additional methods or logic...
    func setActivityToSixDaysAgo(activityId: UUID) {
            if let index = groomingActivities.firstIndex(where: { $0.id == activityId }) {
                groomingActivities[index].lastCompletedDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())
            }
        }
    
}



