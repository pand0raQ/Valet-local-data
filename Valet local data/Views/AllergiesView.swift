//
//  AllergiesView.swift
//  Valet local data
//
//  Created by Анастасия Степаносова on 24.12.2023.
//

import SwiftUI
import PhotosUI

struct AllergyEntry: Codable, Identifiable {
    let id = UUID()
    var rashDate: Date
    var eyesDate: Date
    var scratchingIntensity: String
    var eyesIntensity: String
    var rashImageData: Data?
    var eyesImageData: Data?
}

struct AllergiesView: View {
    @State private var rashDate = Date()
    @State private var eyesDate = Date()
    @State private var scratchingIntensity = "Medium"
    @State private var eyesIntensity = "Medium"
    @State private var showRashImagePicker = false
    @State private var showEyesImagePicker = false
    @State private var rashImage: UIImage?
    @State private var eyesImage: UIImage?
    @State private var allergyEntries: [AllergyEntry] = []

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Rash")) {
                    DatePicker("Date Noticed", selection: $rashDate, displayedComponents: .date)
                    Button("Take or Choose Picture") {
                        showRashImagePicker = true
                    }
                    if let rashImage = rashImage {
                        Image(uiImage: rashImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                }

                Section(header: Text("Scratching Intensity")) {
                    Picker("Intensity", selection: $scratchingIntensity) {
                        Text("High").tag("High")
                        Text("Medium").tag("Medium")
                        Text("Low").tag("Low")
                    }.pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Eyes")) {
                    DatePicker("Date Noticed", selection: $eyesDate, displayedComponents: .date)
                    Button("Take or Choose Picture") {
                        showEyesImagePicker = true
                    }
                    if let eyesImage = eyesImage {
                        Image(uiImage: eyesImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                    Picker("Intensity", selection: $eyesIntensity) {
                        Text("High").tag("High")
                        Text("Medium").tag("Medium")
                        Text("Low").tag("Low")
                    }.pickerStyle(SegmentedPickerStyle())
                }

                Button("Save Entry") {
                    saveAllergyEntry()
                }

                Section(header: Text("History")) {
                    ForEach(allergyEntries) { entry in
                        VStack {
                            Text("Rash Date: \(entry.rashDate, formatter: DateFormatter.shortDate), Intensity: \(entry.scratchingIntensity)")
                            if let rashData = entry.rashImageData, let img = UIImage(data: rashData) {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                                                    .clipped()
                            }
                            Text("Eyes Date: \(entry.eyesDate, formatter: DateFormatter.shortDate), Eyes Intensity: \(entry.eyesIntensity)")
                            if let eyesData = entry.eyesImageData, let img = UIImage(data: eyesData) {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .clipped()
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Allergies")
            .sheet(isPresented: $showRashImagePicker) {
                ImagePickerAllergy(image: $rashImage)
            }
            .sheet(isPresented: $showEyesImagePicker) {
                ImagePickerAllergy(image: $eyesImage)
            }
            .onAppear(perform: loadAllergyEntries)
        }
    }

    private func saveAllergyEntry() {
        let rashData = rashImage?.jpegData(compressionQuality: 1.0)
        let eyesData = eyesImage?.jpegData(compressionQuality: 1.0)
        let newEntry = AllergyEntry(rashDate: rashDate, eyesDate: eyesDate, scratchingIntensity: scratchingIntensity, eyesIntensity: eyesIntensity, rashImageData: rashData, eyesImageData: eyesData)
        allergyEntries.append(newEntry)
        saveEntriesToUserDefaults()
    }

    private func loadAllergyEntries() {
        if let data = UserDefaults.standard.data(forKey: "AllergyEntries"),
           let savedEntries = try? JSONDecoder().decode([AllergyEntry].self, from: data) {
            allergyEntries = savedEntries
        }
    }

    private func saveEntriesToUserDefaults() {
        if let data = try? JSONEncoder().encode(allergyEntries) {
            UserDefaults.standard.set(data, forKey: "AllergyEntries")
        }
    }
}

// DateFormatter extension
extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}
