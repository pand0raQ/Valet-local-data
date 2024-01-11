//
//  AppetiteView.swift
//  Valet local data
//
//  Created by Анастасия Степаносова on 24.12.2023.
//

import SwiftUI

struct AppetiteView: View {
    @State private var appetiteRecord = DogAppetiteRecord()
    @State private var showingSaveConfirmation = false
    @State private var lastRecordedAppetite: DogAppetiteRecord?

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
                    Spacer() // Spacer before the button for centering
                    Button("Save") {
                        saveAppetiteRecord()
                    }
                    .buttonStyle(.borderedProminent) // Bordered and prominent style
                    .tint(.green) // Green color
                    Spacer() // Spacer after the button for centering
                }
               // .padding(.vertical) // Add vertical padding for spacing
                
      
            }
            .navigationBarTitle("Appetite Tracking")
            .onAppear(perform: loadLastRecordedData)
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

        if let encoded = try? JSONEncoder().encode(recordToSave) {
            UserDefaults.standard.set(encoded, forKey: "DogAppetiteRecord")
            showingSaveConfirmation = true
            lastRecordedAppetite = recordToSave
        }
    }

    private func loadLastRecordedData() {
        if let savedData = UserDefaults.standard.data(forKey: "DogAppetiteRecord"),
           let savedAppetiteRecord = try? JSONDecoder().decode(DogAppetiteRecord.self, from: savedData) {
            lastRecordedAppetite = savedAppetiteRecord
        }
    }
}

struct AppetiteView_Previews: PreviewProvider {
    static var previews: some View {
        AppetiteView()
    }
}
