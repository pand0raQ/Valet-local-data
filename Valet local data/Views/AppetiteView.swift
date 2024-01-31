
import SwiftUI
struct AppetiteView: View {
    @State private var appetiteRecord = DogAppetiteRecord() // For recording a new entry
    @State private var showingSaveConfirmation = false
    @State private var appetiteRecords: [DogAppetiteRecord] = [] // Holds all records

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Food given")) {
                    TextField("Amount of Food (mg)", text: $appetiteRecord.foodAmount)
                    TextField("Brand of Dog Food", text: $appetiteRecord.foodBrand)
                }
                
                Section(header: Text("Water given")) {
                    TextField("Amount of Water (ml)", text: $appetiteRecord.waterIntake)
                }
                
                HStack {
                    Spacer()
                    Button("Save") {
                        saveAppetiteRecord()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    Spacer()
                }
            }
            .navigationBarTitle("Appetite Tracking")
            .onAppear {
                loadLastRecordedData()
            }
            .alert(isPresented: $showingSaveConfirmation) {
                Alert(title: Text("Data saved successfully"), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func saveAppetiteRecord() {
        var recordToSave = appetiteRecord
        // Convert strings to integers before saving
        recordToSave.foodAmount = String(Int(appetiteRecord.foodAmount) ?? 0)
        recordToSave.waterIntake = String(Int(appetiteRecord.waterIntake) ?? 0)

        // Fetch existing records and append new record
        var existingRecords = loadLastRecordedData()
        existingRecords.append(recordToSave)

        // Encode and save the updated array back to UserDefaults
        if let encoded = try? JSONEncoder().encode(existingRecords) {
            UserDefaults.standard.set(encoded, forKey: "DogAppetiteRecordsArray")
            showingSaveConfirmation = true
            appetiteRecords = existingRecords // Update state with new list
        }
    }
    
    private func loadLastRecordedData() -> [DogAppetiteRecord] {
        guard let savedData = UserDefaults.standard.data(forKey: "DogAppetiteRecordsArray"),
              let savedRecords = try? JSONDecoder().decode([DogAppetiteRecord].self, from: savedData) else {
            return []
        }
        appetiteRecords = savedRecords // Update the state with loaded records
        return savedRecords
    }
}

struct AppetiteView_Previews: PreviewProvider {
    static var previews: some View {
        AppetiteView()
    }
}
