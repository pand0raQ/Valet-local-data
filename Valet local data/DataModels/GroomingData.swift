

import Foundation

struct GroomingActivity: Identifiable {
    let id = UUID()
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
}

class GroomingViewModel: ObservableObject {
    @Published var groomingActivities: [GroomingActivity] = [
        GroomingActivity(activityName: "Ears Cleaning", frequencyInWeeks: 1, lastCompletedDate: Date()),
        GroomingActivity(activityName: "Teeth Cleaning", frequencyInWeeks: 2, lastCompletedDate: Date()),
        GroomingActivity(activityName: "Paws Clipping", frequencyInWeeks: 4, lastCompletedDate: Date()),
        GroomingActivity(activityName: "Bath", frequencyInWeeks: 8, lastCompletedDate: Date()),
        GroomingActivity(activityName: "Grooming", frequencyInWeeks: 6, lastCompletedDate: Date())
    ]

}


