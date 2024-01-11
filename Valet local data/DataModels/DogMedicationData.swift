
import Foundation
import SwiftUI

// NotificationTime struct with identifier for the notification
enum AppModels {
    
    class NotificationTime: ObservableObject, Identifiable, Codable, Hashable {
        @Published var administered: Bool = false
        var id: UUID
        var date: Date
        var identifier: String // Unique identifier for the notification
        static func == (lhs: NotificationTime, rhs: NotificationTime) -> Bool {
              lhs.id == rhs.id
          }

          func hash(into hasher: inout Hasher) {
              hasher.combine(id)
          }

        init(id: UUID = UUID(), date: Date, identifier: String = UUID().uuidString, administered: Bool = false) {
            self.id = id
            self.date = date
            self.identifier = identifier
            self.administered = administered
        }

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(UUID.self, forKey: .id)
            date = try container.decode(Date.self, forKey: .date)
            identifier = try container.decode(String.self, forKey: .identifier)
            // Decode the administered property
            administered = try container.decode(Bool.self, forKey: .administered)
        }

        enum CodingKeys: String, CodingKey {
            case id, date, identifier, administered
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(date, forKey: .date)
            try container.encode(identifier, forKey: .identifier)
            // Encode the administered property
            try container.encode(administered, forKey: .administered)
        }
    }

    
    // DogMedicationRecord class for medication management
    class DogMedicationRecord: Identifiable, Codable, ObservableObject {
        var id: UUID
        var medicationName: String
        var dosage: String
        var scheduleType: String // "Daily" or "Irregular Schedule"
        var durationInWeeks: Int? // Only used for "Daily"
        var dailyTimes: [NotificationTime]? // Now includes identifier
        var irregularTimes: [NotificationTime]? // Now includes identifier
        
        init(medicationName: String, dosage: String, scheduleType: String, durationInWeeks: Int? = nil, dailyTimes: [NotificationTime]? = nil, irregularTimes: [NotificationTime]? = nil) {
            self.id = UUID()
            self.medicationName = medicationName
            self.dosage = dosage
            self.scheduleType = scheduleType
            self.durationInWeeks = durationInWeeks
            self.dailyTimes = dailyTimes
            self.irregularTimes = irregularTimes
        }
        
        // Codable conformance
        enum CodingKeys: String, CodingKey {
            case id, medicationName, dosage, scheduleType, durationInWeeks, dailyTimes, irregularTimes
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(UUID.self, forKey: .id)
            medicationName = try container.decode(String.self, forKey: .medicationName)
            dosage = try container.decode(String.self, forKey: .dosage)
            scheduleType = try container.decode(String.self, forKey: .scheduleType)
            durationInWeeks = try container.decodeIfPresent(Int.self, forKey: .durationInWeeks)
            dailyTimes = try container.decodeIfPresent([NotificationTime].self, forKey: .dailyTimes)
            irregularTimes = try container.decodeIfPresent([NotificationTime].self, forKey: .irregularTimes)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(medicationName, forKey: .medicationName)
            try container.encode(dosage, forKey: .dosage)
            try container.encode(scheduleType, forKey: .scheduleType)
            try container.encodeIfPresent(durationInWeeks, forKey: .durationInWeeks)
            try container.encodeIfPresent(dailyTimes, forKey: .dailyTimes)
            try container.encodeIfPresent(irregularTimes, forKey: .irregularTimes)
        }
    }
}

