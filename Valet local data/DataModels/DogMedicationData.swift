
import Foundation
import SwiftUI


enum AppModels {
    
    class NotificationTime: ObservableObject, Identifiable, Codable, Hashable {
        @Published var administered: Bool = false
        var timeId: UUID
        var date: Date
        var identifier: String // Unique identifier for the notification
        
        static func == (lhs: NotificationTime, rhs: NotificationTime) -> Bool {
            lhs.timeId == rhs.timeId
          }

        func hash(into hasher: inout Hasher) {
                hasher.combine(timeId) // Assuming 'id' is unique for each instance
            }
        
        
        init(timeId: UUID = UUID(), date: Date, identifier: String = UUID().uuidString, administered: Bool = false) {
            self.timeId = timeId
            self.date = date
            self.identifier = identifier
            self.administered = administered
            print("Initialized NotificationTime - ID: \(timeId), Date: \(date), Administered: \(administered)")

        }

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            timeId = try container.decode(UUID.self, forKey: .timeId)
            date = try container.decode(Date.self, forKey: .date)
            identifier = try container.decode(String.self, forKey: .identifier)
            administered = try container.decode(Bool.self, forKey: .administered)
            print("Decoded NotificationTime - ID: \(timeId), Date: \(date), Administered: \(administered)")
        }

        enum CodingKeys: String, CodingKey {
            case timeId = "id", date, identifier, administered
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(timeId, forKey: .timeId)
            try container.encode(date, forKey: .date)
            try container.encode(identifier, forKey: .identifier)
            try container.encode(administered, forKey: .administered)
            print("Encoded NotificationTime - ID: \(timeId), Date: \(date), Administered: \(administered)")
        }
    }

    
    // DogMedicationRecord class for medication management
    class DogMedicationRecord: Identifiable, Codable, ObservableObject {
        var recordId: UUID
        var medicationName: String
        var dosage: String
        var scheduleType: String // "Daily" or "Irregular Schedule"
        var durationInWeeks: Int? // Only used for "Daily"
        var dailyTimes: [NotificationTime]? // Times for daily notifications
        var irregularTimes: [NotificationTime]? // Times for irregular notifications
        
        init(medicationName: String, dosage: String, scheduleType: String, durationInWeeks: Int? = nil, dailyTimes: [NotificationTime]? = nil, irregularTimes: [NotificationTime]? = nil) {
            self.recordId = UUID()
            self.medicationName = medicationName
            self.dosage = dosage
            self.scheduleType = scheduleType
            self.durationInWeeks = durationInWeeks
            self.dailyTimes = dailyTimes
            self.irregularTimes = irregularTimes
        }
        
        // Assuming createDailyTimes is defined elsewhere, or make sure to define it within this class.
        private func createDailyTimes(startingFrom startDate: Date, for durationInWeeks: Int, at selectedTimes: [Date]) -> [AppModels.NotificationTime] {
            var times = [AppModels.NotificationTime]()
            let calendar = Calendar.current
            let numberOfDays = durationInWeeks * 7
            
            for day in 0..<numberOfDays {
                guard let dayDate = calendar.date(byAdding: .day, value: day, to: startDate) else {
                    continue
                }
                
                for selectedTime in selectedTimes {
                    var dateTimeComponents = calendar.dateComponents([.year, .month, .day], from: dayDate)
                    let timeComponents = calendar.dateComponents([.hour, .minute], from: selectedTime)
                    dateTimeComponents.hour = timeComponents.hour
                    dateTimeComponents.minute = timeComponents.minute
                    
                    if let dateTime = calendar.date(from: dateTimeComponents) {
                        let notificationTime = AppModels.NotificationTime(date: dateTime)
                        times.append(notificationTime)
                    }
                }
            }
            
            return times
        }
        
        
        
        func wasAdministered(on date: Date) -> Bool {
                    let allTimes = (dailyTimes ?? []) + (irregularTimes ?? [])
                    return allTimes.contains { $0.administered && Calendar.current.isDate($0.date, inSameDayAs: date) }
                }
            }}
    
    



