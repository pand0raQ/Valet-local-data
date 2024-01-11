import SwiftUI
import UserNotifications

struct ScheduledMedicationsTimelineView: View {
    @Binding var medications: [AppModels.DogMedicationRecord]
    
    var body: some View {
           List {
               ForEach(medications.indices, id: \.self) { index in
                   Section(header: Text(medications[index].medicationName)) {
                       MedicationTimesListView(medication: $medications[index], medications: $medications)
                   }
               }
           }
           .navigationBarTitle("Scheduled Medications")
       }
    
    
    struct MedicationTimesListView: View {
        @Binding var medication: AppModels.DogMedicationRecord
        @Binding var medications: [AppModels.DogMedicationRecord] // Add this line

        
        var body: some View {
            ForEach(medication.dailyTimes ?? [], id: \.id) { time in
                MedicationTimeView(time: time, updateMedication: updateMedication)
            }
            ForEach(medication.irregularTimes ?? [], id: \.id) { time in
                MedicationTimeView(time: time, updateMedication: updateMedication)
            }
        }
        
        private func updateMedication() {
            saveMedication()
        }
        
        private func saveMedication() {
            if let encoded = try? JSONEncoder().encode(medications) {
                UserDefaults.standard.set(encoded, forKey: "SavedMedications")
            }
        }
        
    }
    
    
    struct MedicationTimeView: View {
        @ObservedObject var time: AppModels.NotificationTime
        var updateMedication: () -> Void
        
        var body: some View {
            HStack {
                Text("\(time.date, formatter: itemFormatter)")
                Spacer()
                Button(action: {
                    administerMedication()
                }) {
                    Image(systemName: time.administered ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(time.administered ? .green : .gray)
                }
            }
        }
        
        
        private func administerMedication() {
            time.administered.toggle()
            if time.administered {
                cancelNotification(with: time.identifier)
            }
            updateMedication()  // Notify parent view to handle the change
        }
        
        private func cancelNotification(with identifier: String) {
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        }
    }
}
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

