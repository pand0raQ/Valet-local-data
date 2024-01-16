
import SwiftUI
import UserNotifications


struct ScheduledNotificationsView: View {
    @Binding var medications: [AppModels.DogMedicationRecord]
    @State private var expandedMedicationIds = Set<UUID>()
   
    var body: some View {
        List {
                ForEach(medications.indices, id: \.self) { index in
                    let medication = medications[index]
                    Section(header: Text("\(medication.medicationName) - \(medication.dosage)")) {
                        // Pending Daily Notifications
                        ForEach(medication.dailyTimes?.filter { !$0.administered } ?? [], id: \.id) { time in
                            MedicationTimeView(time: time, onAdministeredStatusChanged: {
                                updateNotificationStatus(medicationIndex: index, time: time)
                            })
                        }
                        .onDelete { offsets in
                            deleteNotification(offsets, for: index, isDaily: true)
                        }

                        // Pending Irregular Notifications
                        ForEach(medication.irregularTimes?.filter { !$0.administered } ?? [], id: \.id) { time in
                            MedicationTimeView(time: time, onAdministeredStatusChanged: {
                                updateNotificationStatus(medicationIndex: index, time: time)
                            })
                        }
                        .onDelete { offsets in
                            deleteNotification(offsets, for: index, isDaily: false)
                        }

                        // Administered Notifications (Daily and Irregular)
                        let administeredTimes = (medication.dailyTimes ?? []).filter({ $0.administered }) + (medication.irregularTimes ?? []).filter({ $0.administered })
                        if !administeredTimes.isEmpty {
                            DisclosureGroup(
                                isExpanded: .constant(expandedMedicationIds.contains(medication.recordId)),
                                content: {
                                    ForEach(administeredTimes, id: \.id) { time in
                                        Text("Administered Notification: \(time.date, formatter: itemFormatter)")
                                    }
                                },
                                label: {
                                    Text("Administered Notifications").bold()
                                }
                            )
                            .onTapGesture {
                                if expandedMedicationIds.contains(medication.recordId) {
                                    expandedMedicationIds.remove(medication.recordId)
                                } else {
                                    expandedMedicationIds.insert(medication.recordId)
                                }
                            }
                        }
                    }
                }
                .onDelete(perform: deleteMedication)
            }
            .navigationBarTitle("Scheduled Medications")
        }

    
    private func pendingTimesIndices(for medication: AppModels.DogMedicationRecord) -> [Int] {
           guard let dailyTimes = medication.dailyTimes else { return [] }
           return dailyTimes.indices.filter { !dailyTimes[$0].administered }
       }
    

    private func updateNotificationStatus(medicationIndex: Int, time: AppModels.NotificationTime) {
        guard medicationIndex < medications.count else {
            print("Invalid medication index: \(medicationIndex)")
            return
        }

        let notificationCenter = UNUserNotificationCenter.current()

        if let timeIndex = medications[medicationIndex].dailyTimes?.firstIndex(where: { $0.id == time.id }) {
            medications[medicationIndex].dailyTimes?[timeIndex].administered = time.administered
            if time.administered {
                // Cancel the notification
                notificationCenter.removePendingNotificationRequests(withIdentifiers: [time.identifier])
                print("Cancelled notification for administered time: \(time.identifier)")
            }
        } else if let timeIndex = medications[medicationIndex].irregularTimes?.firstIndex(where: { $0.id == time.id }) {
            medications[medicationIndex].irregularTimes?[timeIndex].administered = time.administered
            if time.administered {
                // Cancel the notification
                notificationCenter.removePendingNotificationRequests(withIdentifiers: [time.identifier])
                print("Cancelled notification for administered time: \(time.identifier)")
            }
        } else {
            print("Time ID not found in medication record")
            return
        }

        saveMedications()
    }

    private func loadMedications() {
        if let savedItems = UserDefaults.standard.data(forKey: "SavedMedications") {
            do {
                let decodedItems = try JSONDecoder().decode([AppModels.DogMedicationRecord].self, from: savedItems)
                medications = decodedItems
                print("Loaded medications: \(medications)")
                // Debug print for irregular times
                for medication in medications {
                    if let irregularTimes = medication.irregularTimes {
                        
                        for time in irregularTimes {
                            print("Irregular time: \(time.date) for \(medication.medicationName)")
                        }
                    }
                }
            } catch {
                print("Error loading medications: \(error)")
            }
        } else {
            print("No saved medications data found.")
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

