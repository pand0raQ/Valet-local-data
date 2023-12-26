import SwiftUI
import UserNotifications

// Define a structure to represent a medication
struct Medication: Identifiable, Codable {
    var id = UUID()
    var name: String
    var dosage: String
    var duration: Int
    var frequency: String
    var notificationsEnabled: Bool
    var administered: Bool = false // Track if the medication has been administered
}

struct MedicationView: View {
    @State private var medicationName: String = ""
    @State private var dosage: String = ""
    @State private var duration: Int = 1
    @State private var selectedFrequency = 0
    @State private var timesPerDay: Int = 1
    @State private var dailyTimes: [Date] = Array(repeating: Date(), count: 4)
    @State private var notificationTime = Date()
    @State private var notificationsEnabled = false
    @State private var medications: [Medication] = []
    @State private var showingSuccessAlert = false

    private let frequencies = ["Daily", "Every Other Day", "Weekly"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Medication Details")) {
                    TextField("Medication Name", text: $medicationName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Dosage (e.g., 2 pills)", text: $dosage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Picker("Duration (Weeks)", selection: $duration) {
                        ForEach(1..<53, id: \.self) {
                            Text("\($0) week\($0 > 1 ? "s" : "")")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())

                    Picker("Frequency", selection: $selectedFrequency) {
                        ForEach(0..<frequencies.count, id: \.self) {
                            Text(self.frequencies[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    if frequencies[selectedFrequency] == "Daily" {
                        Picker("Times per Day", selection: $timesPerDay) {
                            ForEach(1...4, id: \.self) { count in
                                Text("\(count) time\(count > 1 ? "s" : "")")
                            }
                        }

                        ForEach(0..<timesPerDay, id: \.self) { index in
                            DatePicker("Time \(index + 1)", selection: $dailyTimes[index], displayedComponents: .hourAndMinute)
                        }
                    } else {
                        DatePicker("Notification Time", selection: $notificationTime, displayedComponents: .hourAndMinute)
                    }

                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                }

                Section(header: Text("Medications")) {
                    ForEach(medications) { medication in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(medication.name).font(.headline)
                                Text("Dosage: \(medication.dosage)")
                            }
                            Spacer()
                            Image(systemName: medication.administered ? "checkmark.circle.fill" : "circle")
                                .onTapGesture {
                                    markAsAdministered(medication)
                                }
                        }
                    }
                    .onDelete(perform: deleteMedication)
                }

                Button(action: addMedication) {
                    Text("Add Medication")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .navigationBarTitle("Medications")
            .alert(isPresented: $showingSuccessAlert) {
                Alert(title: Text("Success"), message: Text("Medication saved successfully"), dismissButton: .default(Text("OK")))
            }
        }
        .onAppear(perform: loadMedications)
    }

    private func addMedication() {
        let newMedication = Medication(name: medicationName, dosage: dosage, duration: duration, frequency: frequencies[selectedFrequency], notificationsEnabled: notificationsEnabled)
        medications.append(newMedication)
        saveMedications()
        showingSuccessAlert = true
    }

    private func markAsAdministered(_ medication: Medication) {
        if let index = medications.firstIndex(where: { $0.id == medication.id }) {
            medications[index].administered.toggle()
            saveMedications()
        }
    }

    private func deleteMedication(at offsets: IndexSet) {
        medications.remove(atOffsets: offsets)
        saveMedications()
    }

    private func saveMedications() {
        if let encoded = try? JSONEncoder().encode(medications) {
            UserDefaults.standard.set(encoded, forKey: "SavedMedications")
        }
    }

    private func loadMedications() {
        if let savedItems = UserDefaults.standard.data(forKey: "SavedMedications"),
           let decodedItems = try? JSONDecoder().decode([Medication].self, from: savedItems) {
            medications = decodedItems
        }
    }

    private func scheduleNotification() {
        if frequencies[selectedFrequency] == "Daily" {
            for i in 0..<timesPerDay {
                let adjustedTime = Calendar.current.date(byAdding: .hour, value: i * 24 / timesPerDay, to: notificationTime) ?? notificationTime
                createNotification(date: adjustedTime, identifier: "Daily\(i)")
            }
        } else {
            let interval: TimeInterval = (frequencies[selectedFrequency] == "Every Other Day") ? 86400 * 2 : 86400 * 7
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)
            createNotification(date: notificationTime, identifier: frequencies[selectedFrequency])
        }
    }

    private func createNotification(date: Date, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = "Medication Reminder"
        content.body = "Time to take your \(medicationName)"

        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString + identifier, content: content, trigger: trigger)
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

