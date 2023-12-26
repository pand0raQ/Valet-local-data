import SwiftUI
import UserNotifications

struct MedicationIntake: Identifiable, Codable {
    let id = UUID()
    var dateTime: Date
    var administered: Bool
}

struct Medication: Identifiable, Codable {
    var id = UUID()
    var name: String
    var dosage: String
    var frequency: String
    var intakes: [MedicationIntake]
}

struct MedicationView: View {
    @State private var medicationName: String = ""
    @State private var dosage: String = ""
    @State private var selectedFrequency = "Daily"
    @State private var selectedTimes: [Date] = [Date()]
    @State private var medications: [Medication] = []
    @State private var showingSuccessAlert = false


    private let frequencies = ["Daily", "Every Other Day", "Weekly"]
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Add New Medication")) {
                                   TextField("Medication Name", text: $medicationName)
                                   TextField("Dosage (e.g., 2 pills)", text: $dosage)
                                   Picker("Frequency", selection: $selectedFrequency) {
                                       ForEach(frequencies, id: \.self) { frequency in
                                           Text(frequency)
                                       }
                                   }
                    .pickerStyle(SegmentedPickerStyle())
                    ForEach(selectedTimes.indices, id: \.self) { index in
                                            DatePicker("Time \(index + 1)", selection: $selectedTimes[index], displayedComponents: .hourAndMinute)
                                        }

                                        Button("Add Time", action: { addTime() })
                                        Button("Add Medication", action: { addMedication() })
                                    }


                ForEach(medications.sorted(by: { $0.name < $1.name })) { medication in
                                    Section(header: Text(medication.name)) {
                                        ForEach(medication.intakes.sorted(by: { $0.dateTime < $1.dateTime })) { intake in
                                            HStack {
                                                Text("Take at: \(intake.dateTime, formatter: itemFormatter)")
                                                Spacer()
                                Image(systemName: intake.administered ? "checkmark.circle.fill" : "circle")
                                    .onTapGesture {
                                        markAsAdministered(medicationId: medication.id, intakeId: intake.id)
                                    }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Medications")
            .alert(isPresented: $showingSuccessAlert) {
                Alert(title: Text("Success"), message: Text("Medication added"), dismissButton: .default(Text("OK")))
            }
        }
        .onAppear(perform: loadMedications)
    }
    private func addTime() {
            selectedTimes.append(Date())
        }


    private func addMedication() {
            var intakes = [MedicationIntake]()
            let repeatInterval = selectedFrequency == "Daily" ? 1 : selectedFrequency == "Every Other Day" ? 2 : 7

            for selectedTime in selectedTimes {
                var currentDate = selectedTime
                for _ in 0..<4 { // Assuming 4 weeks of scheduling
                    intakes.append(MedicationIntake(dateTime: currentDate, administered: false))
                    currentDate = Calendar.current.date(byAdding: .day, value: repeatInterval, to: currentDate)!
                }
            }

            let newMedication = Medication(name: medicationName, dosage: dosage, frequency: selectedFrequency, intakes: intakes)
            medications.append(newMedication)
            saveMedications()
        }

    private func markAsAdministered(medicationId: UUID, intakeId: UUID) {
        if let medicationIndex = medications.firstIndex(where: { $0.id == medicationId }),
           let intakeIndex = medications[medicationIndex].intakes.firstIndex(where: { $0.id == intakeId }) {
            medications[medicationIndex].intakes[intakeIndex].administered.toggle()
            saveMedications()
        }
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
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

struct MedicationView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationView()
    }
}

