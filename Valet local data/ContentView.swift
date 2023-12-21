//
//  ContentView.swift
//  Valet local data
//
//  Created by Анастасия Степаносова on 21.12.2023.
//


import SwiftUI

import SwiftUI

struct ContentView: View {
    @State private var dogHealthRecord = DogHealthRecord(
        lastPoopedDateTime: Date(),
        consist: .regular, // Default value
        consistComment: "",
        color: "",
        colorComment: ""
    )
    @State private var showingSaveConfirmation = false

    var body: some View {
        NavigationView {
            Form {
                DatePicker("Last Pooped Time", selection: $dogHealthRecord.lastPoopedDateTime)

                Picker("Consistency", selection: $dogHealthRecord.consist) {
                    ForEach(Consistency.allCases, id: \.self) { value in
                        Text(value.rawValue).tag(value)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                TextField("Consistency Comment", text: $dogHealthRecord.consistComment)
                TextField("Color", text: $dogHealthRecord.color)
                TextField("Color Comment", text: $dogHealthRecord.colorComment)
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
            consist: .regular,
            consistComment: "",
            color: "",
            colorComment: ""
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
