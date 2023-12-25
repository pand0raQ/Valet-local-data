//
//  poopingView.swift
//  Valet local data
//
//  Created by Анастасия Степаносова on 24.12.2023.
//

import Foundation

import SwiftUI

struct poopingView: View {
    @State private var dogHealthRecord = DogHealthRecord(
        lastPoopedDateTime: Date(),
        consist: .regular,
        consistComment: "",
        color: ""
    )
    @State private var showingSaveConfirmation = false
    @State private var showingConsistencyAlert = false
    @State private var temporaryConsistencyComment = ""
    var body: some View {
        NavigationView {
            Form {
                DatePicker("Last Pooped Time", selection: $dogHealthRecord.lastPoopedDateTime)
                Section(header: Text("Consistency").font(.footnote)) {
                    Picker("Select Consistency", selection: $dogHealthRecord.consist) {
                        ForEach(Consistency.allCases, id: \.self) { value in
                            Text(value.rawValue).tag(value)
                        }
                    }
                }
              
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: dogHealthRecord.consist) { newValue in
                    if newValue == .constipation || newValue == .droopy || newValue == .diarrhoea {
                        self.showingConsistencyAlert = true
                    }
                }

                TextField("Color", text: $dogHealthRecord.color)

                Button("Save") {
                    saveToUserDefaults()
                }
                

                NavigationLink(destination: poopingStoredDataView()) {
                    Text("View Stored Data")
                }
                // Display the saved data
                if let savedRecord = loadFromUserDefaults() {
                    Text("Last Pooped Time: \(savedRecord.lastPoopedDateTime, formatter: dateFormatter)")
                    Text("Consistency: \(savedRecord.consist.rawValue)")
                    Text("Consistency Comment: \(savedRecord.consistComment)")
                    Text("Color: \(savedRecord.color)")
                    
                } else {
                    Text("No data saved")
                }
            }
        
        
            .navigationBarTitle("Pooping")
            
            .alert(isPresented: $showingSaveConfirmation) {
                Alert(title: Text("Saved"), message: Text("Your entry has been saved successfully."), dismissButton: .default(Text("OK")))
            }
            .alert("Any idea why?", isPresented: $showingConsistencyAlert) {
                TextField("Comment", text: $temporaryConsistencyComment)
                Button("Submit") {
                    dogHealthRecord.consistComment = temporaryConsistencyComment
                    temporaryConsistencyComment = ""
                }
                
            }


        }
        
    }

    private func loadFromUserDefaults() -> DogHealthRecord? {
        if let savedData = UserDefaults.standard.data(forKey: "DogHealthRecord") {
            let decoder = JSONDecoder()
            if let loadedRecord = try? decoder.decode(DogHealthRecord.self, from: savedData) {
                return loadedRecord
            }
        }
        return nil
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter
    }()
    
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
            color: ""
        )
    }
}

struct poopingView_Previews: PreviewProvider {
    static var previews: some View {
        poopingView()
    }
}
