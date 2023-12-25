//
//  DogMedicationData.swift
//  Valet local data
//
//  Created by Анастасия Степаносова on 24.12.2023.
//


import Foundation

class DogMedicationRecord: ObservableObject, Identifiable, Codable {
    @Published var id = UUID()
    @Published var medicationName: String = ""
    @Published var dosage: String = ""
    @Published var durationInWeeks: Int = 0
    @Published var notificationTime: Date = Date()
    @Published var notificationDays: [String] = []

    enum CodingKeys: CodingKey {
        case id, medicationName, dosage, durationInWeeks, notificationTime, notificationDays
    }

    init(medicationName: String = "", dosage: String = "", durationInWeeks: Int = 1, notificationTime: Date = Date(), notificationDays: [String] = []) {
        self.medicationName = medicationName
        self.dosage = dosage
        self.durationInWeeks = durationInWeeks
        self.notificationTime = notificationTime
        self.notificationDays = notificationDays
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        medicationName = try container.decode(String.self, forKey: .medicationName)
        dosage = try container.decode(String.self, forKey: .dosage)
        durationInWeeks = try container.decode(Int.self, forKey: .durationInWeeks)
        notificationTime = try container.decode(Date.self, forKey: .notificationTime)
        notificationDays = try container.decode([String].self, forKey: .notificationDays)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(medicationName, forKey: .medicationName)
        try container.encode(dosage, forKey: .dosage)
        try container.encode(durationInWeeks, forKey: .durationInWeeks)
        try container.encode(notificationTime, forKey: .notificationTime)
        try container.encode(notificationDays, forKey: .notificationDays)
    }
}

