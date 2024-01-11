
import SwiftUI
import UserNotifications

struct ScheduledNotificationsView: View {
    @Binding var medications: [AppModels.DogMedicationRecord]

    var body: some View {
        List {
            ForEach(medications.indices, id: \.self) { index in
                Section(header: Text(medications[index].medicationName)) {
                    Text("Medication name: \(medications[index].medicationName)")
                    Text("Dosage: \(medications[index].dosage)")
                    
                    if let dailyTimes = medications[index].dailyTimes, !dailyTimes.isEmpty {
                        ForEach(dailyTimes, id: \.id) { notificationTime in
                            Text("Daily Notification: \(notificationTime.date, formatter: itemFormatter)")
                        }
                        .onDelete { offsets in
                            deleteNotification(offsets, for: index, isDaily: true)
                        }
                    }
                    
                    if let irregularTimes = medications[index].irregularTimes, !irregularTimes.isEmpty {
                        ForEach(irregularTimes, id: \.id) { notificationTime in
                            Text("Irregular Notification: \(notificationTime.date, formatter: itemFormatter)")
                            
                        }
                        .onDelete { offsets in
                            deleteNotification(offsets, for: index, isDaily: false)
                        }
                    }
                }
            }
            .onDelete(perform: deleteMedication)
            .onAppear(perform: loadMedications)
        }
        .navigationBarTitle("Scheduled Medications")
    }

    private func loadMedications() {
        if let savedItems = UserDefaults.standard.data(forKey: "SavedMedications") {
            do {
                let decodedItems = try JSONDecoder().decode([AppModels.DogMedicationRecord].self, from: savedItems)
                medications = decodedItems
            } catch {
                print("Error loading medications: \(error)")
            }
        }
    }

    private func deleteMedication(at offsets: IndexSet) {
        print("Deleting medication at offsets: \(offsets)")

        offsets.forEach { index in
            guard index < medications.count else {
                print("Index out of range: \(index)")
                
                return
            }
            print("Removing medication at index: \(index), Name: \(medications[index].medicationName)")

            removeNotifications(for: medications[index])
            medications.remove(at: index)
        }
        saveMedications()
    }

    private func deleteNotification(_ offsets: IndexSet, for medicationIndex: Int, isDaily: Bool) {
        print("Deleting notification at offsets: \(offsets) for medicationIndex: \(medicationIndex), isDaily: \(isDaily)")

        guard medicationIndex < medications.count else {
            print("Medication index out of range: \(medicationIndex)")
            return
        }

        var medication = medications[medicationIndex]
        let notificationCenter = UNUserNotificationCenter.current()

        if isDaily {
            offsets.forEach { index in
                guard let dailyTime = medication.dailyTimes?[index] else { return }
                print("Removing Daily Notification Identifier: \(dailyTime.identifier)")

                notificationCenter.removePendingNotificationRequests(withIdentifiers: [dailyTime.identifier])
            }
            medication.dailyTimes?.remove(atOffsets: offsets)
        } else {
            offsets.forEach { index in
                guard let irregularTime = medication.irregularTimes?[index] else { return }
                print("Removing Irregular Notification Identifier: \(irregularTime.identifier)")

                notificationCenter.removePendingNotificationRequests(withIdentifiers: [irregularTime.identifier])
            }
            medication.irregularTimes?.remove(atOffsets: offsets)
        }

        medications[medicationIndex] = medication
        saveMedications()
    }

    private func removeNotifications(for medication: AppModels.DogMedicationRecord) {
        print("Removing notifications for medication: \(medication.medicationName)")

        let notificationCenter = UNUserNotificationCenter.current()
        let identifiers = (medication.dailyTimes?.map { $0.identifier } ?? []) +
                          (medication.irregularTimes?.map { $0.identifier } ?? [])
        print("Identifiers being removed: \(identifiers)")

        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    private func saveMedications() {
        do {
            let encoded = try JSONEncoder().encode(medications)
            UserDefaults.standard.set(encoded, forKey: "SavedMedications")
            print("Medications saved successfully.")

        } catch {
            print("Error saving medications: \(error)")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

