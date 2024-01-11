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
            
        }
        .onAppear {
            loadMedications()
        }
    }
    
    
    private func loadMedications() {
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.data(forKey: "SavedMedications") {
            let decoder = JSONDecoder()
            
            do {
                let loadedMedications = try decoder.decode([AppModels.DogMedicationRecord].self, from: savedData)
                self.medications = loadedMedications
                print("Loaded medications: \(loadedMedications)")
            } catch {
                print("Failed to load medications: \(error)")
            }
        } else {
            print("No saved medications data found.")
            // Optionally load default or mock data for testing
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
