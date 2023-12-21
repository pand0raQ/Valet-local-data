//
//  ContentView.swift
//  Valet local data
//
//  Created by Анастасия Степаносова on 21.12.2023.
//


import SwiftUI

struct ContentView: View {
    @State private var dogHealthRecord = DogHealthRecord(
        lastPoopedDateTime: Date(),
        consist: "",
        consistComment: "",
        color: "",
        colorComment: "",
        eatenAmountPerHour: "",
        brandName: "",
        waterAmount: ""
    )
    @State private var showingSaveConfirmation = false

    var body: some View {
        NavigationView {
            Form {
                DatePicker("Last Pooped Time", selection: $dogHealthRecord.lastPoopedDateTime)
                TextField("Consistency", text: $dogHealthRecord.consist)
                TextField("Consistency Comment", text: $dogHealthRecord.consistComment)
                TextField("Color", text: $dogHealthRecord.color)
                TextField("Color Comment", text: $dogHealthRecord.colorComment)
                TextField("Eaten Amount per Hour", text: $dogHealthRecord.eatenAmountPerHour)
                TextField("Brand Name", text: $dogHealthRecord.brandName)
                TextField("Water Amount", text: $dogHealthRecord.waterAmount)

                Button("Save") {
                    saveToUserDefaults()
                }

                NavigationLink(destination: StoredDataView()) {
                    Text("View Stored Data")
                }
            }
            .navigationBarTitle("Dog Health Tracker")
            .alert(isPresented: $showingSaveConfirmation) {
                Alert(title: Text("Saved"), message: Text("Your entry has been saved successfully."), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(dogHealthRecord) {
            UserDefaults.standard.set(encoded, forKey: "DogHealthRecord")
            showingSaveConfirmation = true
            resetForm()
        }
    }

    private func resetForm() {
        dogHealthRecord = DogHealthRecord(
            lastPoopedDateTime: Date(),
            consist: "",
            consistComment: "",
            color: "",
            colorComment: "",
            eatenAmountPerHour: "",
            brandName: "",
            waterAmount: ""
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}