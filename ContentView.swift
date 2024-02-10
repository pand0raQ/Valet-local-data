
import SwiftUI

struct ContentView: View {
    @State private var medications: [AppModels.DogMedicationRecord] = []
    @StateObject var groomingViewModel = GroomingViewModel()

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State  var poopingLogs: [PoopingData]

    
    
    var body: some View {
        NavigationView {
           MainView(poopingLogs: poopingLogs)
        }
        .onAppear {
           loadMedications()
          //  loadPoopingData()

        }
    }
    
    
    private func loadMedications() {
        if let savedItems = UserDefaults.standard.data(forKey: "SavedMedications") {
            do {
                let decodedItems = try JSONDecoder().decode([AppModels.DogMedicationRecord].self, from: savedItems)
                medications = decodedItems
                print("Loaded medications: \(medications)")

                // Debug print for daily and irregular times
                for medication in medications {
                    print("Medication: \(medication.medicationName), Dosage: \(medication.dosage)")

                    if let dailyTimes = medication.dailyTimes {
                        for time in dailyTimes {
                            print("Daily time: \(time.date) for \(medication.medicationName)")
                        }
                    }

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
    private func loadPoopingData() -> PoopingData {
        if let savedData = UserDefaults.standard.data(forKey: "PoopingData") {
            let decoder = JSONDecoder()
            if let loadedRecord = try? decoder.decode(PoopingData.self, from: savedData),
               loadedRecord.lastPoopedDateTime != nil {
                return loadedRecord
            }else {
                print("Failed to decode PoopingData")
            }
        } else {
                print("No PoopingData found in UserDefaults")
            }
        
        return PoopingData()
    }
    
    
  }
    
    
