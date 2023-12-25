import SwiftUI
import UserNotifications

struct MedicationView: View {
    @State private var medicationName: String = ""
    @State private var dosage: String = ""
    @State private var duration: Int = 1 // Duration in weeks
    @State private var selectedFrequency = 0
    @State private var notificationTime = Date()
    @State private var notificationsEnabled = false
    @State private var savedMedications: [String] = []

    private let frequencies = ["Daily", "Every Other Day", "Weekly"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Medication Details")) {
                    TextField("Medication Name", text: $medicationName)
                    TextField("Dosage (e.g., 2 pills)", text: $dosage)
                    Picker("Duration (Weeks)", selection: $duration) {
                        ForEach(1..<53, id: \.self) {
                            Text("\($0) week\($0 > 1 ? "s" : "")")
                        }
                    }
                    Picker("Frequency", selection: $selectedFrequency) {
                        ForEach(0..<frequencies.count, id: \.self) {
                            Text(self.frequencies[$0])
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    DatePicker("Notification Time", selection: $notificationTime, displayedComponents: .hourAndMinute)
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                }

                Button(action: saveMedication) {
                    Text("Save Medication")
                        .frame(maxWidth: .infinity)
                }

                Section(header: Text("Saved Medications")) {
                    List(savedMedications, id: \.self) { medication in
                        Text(medication)
                    }
                }
            }
            .navigationBarTitle("Medications")
            .onAppear(perform: loadMedications)
        }
    }

    private func saveMedication() {
        let defaults = UserDefaults.standard
        let medicationDetail = "\(medicationName), \(dosage), \(duration) weeks, \(frequencies[selectedFrequency]), \(notificationsEnabled ? "Notifications On" : "Notifications Off")"
        savedMedications.append(medicationDetail)
        defaults.set(savedMedications, forKey: "SavedMedications")

        if notificationsEnabled {
            scheduleNotification()
        }
    }

    private func loadMedications() {
        let defaults = UserDefaults.standard
        savedMedications = defaults.object(forKey: "SavedMedications") as? [String] ?? []
    }

    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Medication Reminder"
        content.body = "Time to take your \(medicationName)"

        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: notificationTime)

        var trigger: UNNotificationTrigger
        switch frequencies[selectedFrequency] {
        case "Daily":
            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        case "Every Other Day":
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400 * 2, repeats: true)
        case "Weekly":
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400 * 7, repeats: true)
        default:
            return
        }

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}

struct MedicationView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationView()
    }
}

