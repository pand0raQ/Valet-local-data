import SwiftUI
import UserNotifications

struct ScheduledMedicationsTimelineView: View {
    @Binding var medications: [AppModels.DogMedicationRecord]

    var body: some View {
        List {
            ForEach(medications, id: \.id) { medication in
                Section(header: Text("\(medication.medicationName) - \(medication.dosage)")) {
                    ForEach(medication.dailyTimes ?? [], id: \.id) { time in
                        MedicationTimeView(time: time, onAdministeredStatusChanged: {
                            updateMedicationTimeStatus(medication: medication, time: time)
                        })
                    }
                    ForEach(medication.irregularTimes ?? [], id: \.id) { time in
                        MedicationTimeView(time: time, onAdministeredStatusChanged: {
                            updateMedicationTimeStatus(medication: medication, time: time)
                        })
                    }
                }
            }
        }
        .navigationBarTitle("Scheduled Medications")
    }

    private func updateMedicationTimeStatus(medication: AppModels.DogMedicationRecord, time: AppModels.NotificationTime) {
        if let medicationIndex = medications.firstIndex(where: { $0.id == medication.id }) {
            if let timeIndex = medications[medicationIndex].dailyTimes?.firstIndex(where: { $0.id == time.id }) {
                medications[medicationIndex].dailyTimes?[timeIndex].administered = time.administered
            } else if let timeIndex = medications[medicationIndex].irregularTimes?.firstIndex(where: { $0.id == time.id }) {
                medications[medicationIndex].irregularTimes?[timeIndex].administered = time.administered
            }
            saveMedications()
        }
    }

    private func saveMedications() {
        // Implement your saving logic here, such as encoding and saving to UserDefaults
    }
}

struct MedicationTimeView: View {
    @ObservedObject var time: AppModels.NotificationTime
    var onAdministeredStatusChanged: () -> Void

    var body: some View {
        HStack {
            Text("\(time.date, formatter: itemFormatter)")
            Spacer()
            Button(action: {
                time.administered.toggle()
                onAdministeredStatusChanged()
            }) {
                Image(systemName: time.administered ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(time.administered ? .green : .gray)
            }
        }
    }
}// You can reuse the existing implementation or make necessary modifications

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()












//
//import SwiftUI
//import UserNotifications
//
//struct ScheduledMedicationsTimelineView: View {
//    @Binding var medications: [AppModels.DogMedicationRecord]
//
//    var body: some View {
//        List {
//            ForEach(medications, id: \.id) { medication in
//                Section(header: Text("\(medication.medicationName) - \(medication.dosage)")) {
//                    ForEach(medication.dailyTimes ?? [], id: \.id) { time in
//                        MedicationTimeView(time: time, onAdministeredStatusChanged: {
//                            updateMedicationTimeStatus(medication: medication, time: time)
//                        })
//                    }
//                    ForEach(medication.irregularTimes ?? [], id: \.id) { time in
//                        MedicationTimeView(time: time, onAdministeredStatusChanged: {
//                            updateMedicationTimeStatus(medication: medication, time: time)
//                        })
//                    }
//                }
//            }
//        }
//        .navigationBarTitle("Scheduled Medications")
//    }
//}
//    private func updateMedicationTimeStatus(medication: AppModels.DogMedicationRecord, time: AppModels.NotificationTime) {
//        // Find the index of the medication in the medications array
//        if let medicationIndex = medications.firstIndex(where: { $0.id == medication.id }) {
//            // Check and update in dailyTimes
//            if let timeIndex = medications[medicationIndex].dailyTimes?.firstIndex(where: { $0.id == time.id }) {
//                medications[medicationIndex].dailyTimes?[timeIndex].administered = time.administered
//            }
//            // Check and update in irregularTimes
//            else if let timeIndex = medications[medicationIndex].irregularTimes?.firstIndex(where: { $0.id == time.id }) {
//                medications[medicationIndex].irregularTimes?[timeIndex].administered = time.administered
//            }
//            // Save updated medications to persistent storage, if needed
//            saveMedications()
//        }
//    }
//
//}
//struct MedicationStatusSectionView: View {
//    var title: String
//    @Binding var medications: [AppModels.DogMedicationRecord]
//    var filter: (AppModels.DogMedicationRecord) -> Bool
//
//    var filteredMedications: [AppModels.DogMedicationRecord] {
//        medications.filter(filter)
//    }
//
//    var body: some View {
//        if !filteredMedications.isEmpty {
//            Section(header: Text(title)) {
//                ForEach(filteredMedications, id: \.id) { medication in
//                    MedicationGroupView(medication: medication, medications: $medications)
//                }
//            }
//        }
//    }
//}
//struct MedicationGroupView: View {
//    var medication: AppModels.DogMedicationRecord
//    @Binding var medications: [AppModels.DogMedicationRecord]
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("\(medication.medicationName) - \(medication.dosage)")
//                .font(.headline)
//                .padding(.vertical, 5)
//            
//            ForEach(medication.pendingTimes + medication.administeredTimes, id: \.id) { time in
//                MedicationTimeView(time: time, onAdministeredStatusChanged: {
//                    updateMedicationTimeStatus(for: time)
//                })
//            }
//        }
//    }
//    
//    
//
//
//    private func updateMedications() {
//        
//        // Logic to update medications in the parent view
//        // This could involve sorting or filtering based on the administered status
//    }
//}
//struct MedicationTimeView: View {
//    @ObservedObject var time: AppModels.NotificationTime
//    var onAdministeredStatusChanged: () -> Void  // Callback to inform the parent view
//
//    var body: some View {
//        HStack {
//            Text("\(time.date, formatter: itemFormatter)")
//            Spacer()
//            Button(action: {
//                administerMedication()
//            }) {
//                Image(systemName: time.administered ? "checkmark.circle.fill" : "circle")
//                    .foregroundColor(time.administered ? .green : .gray)
//            }
//        }
//    }
//
//    private func administerMedication() {
//        print("Before Toggle: \(time.administered) for time ID: \(time.id)")
//
//        time.administered.toggle()
//        print("After Toggle: \(time.administered) for time ID: \(time.id)")
//
//        if time.administered {
//            cancelNotification(with: time.identifier)
//        }
//        onAdministeredStatusChanged() // Notify the parent view to refresh or re-sort the list
//    }
//
//    private func cancelNotification(with identifier: String) {
//        let notificationCenter = UNUserNotificationCenter.current()
//        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
//    }
//}
//
//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .medium
//    formatter.timeStyle = .short
//    return formatter
//}()
//
