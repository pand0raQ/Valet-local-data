//
//  ContentView.swift
//  Valet local data
//
//  Created by Анастасия Степаносова on 21.12.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var medications: [AppModels.DogMedicationRecord] = []
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    
    
    var body: some View {
        NavigationView {
            
             DashboardView(medications: $medications)
           // AllergiesView()
        }
    }
    
      //  .onAppear {
          //  loadMedications()
            
        //}
   // }
    
    
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
    
    

}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
