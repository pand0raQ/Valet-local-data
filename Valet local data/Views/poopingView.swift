//
//  poopingView.swift
//  Valet local data
//
//  Created by Анастасия Степаносова on 24.12.2023.
//

import Foundation

import SwiftUI

struct poopingView: View {
    @State private var poopingData = PoopingData(
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
                DatePicker(
                    selection: $poopingData.lastPoopedDateTime,
                    displayedComponents: [.date, .hourAndMinute]
                ){
                    Text("")
                }
                                .datePickerStyle(WheelDatePickerStyle())
                
                Section(header: Text("Consistency").font(.footnote)) {
                    Picker("Select Consistency", selection: $poopingData.consist) {
                        ForEach(Consistency.allCases, id: \.self) { value in
                            Text(value.rawValue).tag(value)
                        }
                    }
                }
              
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: poopingData.consist) { newValue in
                    if newValue == .constipation || newValue == .droopy || newValue == .diarrhoea {
                        self.showingConsistencyAlert = true
                    }
                }

                TextField("Color", text: $poopingData.color)
                
                HStack {
                                    Spacer() // Spacer before the button for centering
                                    Button("Save") {
                                        saveToUserDefaults()
                                    }
                                    .buttonStyle(.borderedProminent) // Bordered and prominent style
                                    .tint(.green) // Green color
                                    Spacer() // Spacer after the button for centering
                                }
                                .padding(.vertical) // Add vertical padding for spacing


            }
            
            .alert(isPresented: $showingSaveConfirmation) {
                Alert(title: Text("Saved"), message: Text("Your entry has been saved successfully."), dismissButton: .default(Text("OK")))
            }
            .alert("Any idea why?", isPresented: $showingConsistencyAlert) {
                TextField("Comment", text: $temporaryConsistencyComment)
                Button("Submit") {
                    poopingData.consistComment = temporaryConsistencyComment
                    temporaryConsistencyComment = ""
                }
                
            }

            .navigationTitle("Pooping Log")
            .navigationBarTitleDisplayMode(.inline)
        }
        
        
    }
    

    private func loadFromUserDefaults() -> PoopingData? {
        if let savedData = UserDefaults.standard.data(forKey: "PoopingData") {
            let decoder = JSONDecoder()
            if let loadedRecord = try? decoder.decode(PoopingData.self, from: savedData) {
                return loadedRecord
            }
        }
        return nil
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(poopingData) {
            UserDefaults.standard.set(encoded, forKey: "PoopingData")
            showingSaveConfirmation = true
            resetForm()
        }
    }

    private func resetForm() {
        poopingData = PoopingData (
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
