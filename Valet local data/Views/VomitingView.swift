

import SwiftUI
import UIKit

struct VomitingView: View {
   // @State private var vomitDateTime = Date()
    @State private var showingImagePicker = false
    @State private var sourceType: ImagePicker.SourceType = .photoLibrary
    @State private var inputImage: UIImage?
    @State private var displayImage: Image?
    @State private var showingSaveAlert = false
    @State private var saveAlertMessage = ""
    @State private var vomitingData = VomitingData(lastVomitDateTime: Date() )

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    DatePicker("", selection: $vomitingData.lastVomitDateTime, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(WheelDatePickerStyle())
                        .padding()
                        .onAppear { print("DatePicker appeared") }
                        .onDisappear { print("DatePicker disappeared") }

                    if let displayImage = displayImage {
                        displayImage
                            .resizable()
                            .scaledToFit()
                            .onAppear { print("Display Image appeared") }
                            .onDisappear { print("Display Image disappeared") }
                    } else {
                        HStack {
                            Button("Take Picture") {
                                self.sourceType = .camera
                                self.showingImagePicker = true
                                print("Take Picture button tapped")
                            }
                            .padding()
                            .buttonStyle(.bordered)

                            Button("Select Picture") {
                                self.sourceType = .photoLibrary
                                self.showingImagePicker = true
                                print("Select Picture button tapped")
                            }
                            .padding()
                            .buttonStyle(.bordered)
                        }
                    }

                    Button("Save") {
                        saveData()
                        print("Save button tapped")
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }
            }
            .navigationTitle("Vomiting Log")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { print("VomitingView appeared") }
            .onDisappear { print("VomitingView disappeared") }
            .sheet(isPresented: $showingImagePicker, onDismiss: {
                loadImage()
                print("ImagePicker is dismissed")
            }) {
                ImagePicker(sourceType: self.sourceType, image: self.$inputImage, onDismiss: {
                        self.showingImagePicker = false  // Set the state to false when the picker is dismissed
                        print("Custom onDismiss closure called")
                    })
                }
            }
            .alert(isPresented: $showingSaveAlert) {
                Alert(title: Text("Save Status"), message: Text(saveAlertMessage), dismissButton: .default(Text("OK")))
            }
        }

    private func saveData() {
        // Attempt to save image data if available
        if let imageData = inputImage?.jpegData(compressionQuality: 1.0) {
            UserDefaults.standard.set(imageData, forKey: "vomitImageData") // Consider using a unique key for each image
            print("Image data saved successfully.")
        } else {
            print("No image data to save.")
        }

        // Load existing vomiting data
        var existingData = loadVomitingData()
        print("Loaded existing vomiting data: \(existingData.count) entries found.")

        // Append new vomiting data
        existingData.append(vomitingData)
        print("Appended new vomiting data, total entries now: \(existingData.count).")

        // Encode and save the updated array to UserDefaults
        if let encoded = try? JSONEncoder().encode(existingData) {
            UserDefaults.standard.set(encoded, forKey: "VomitingDataArray")
            print("Vomiting data array saved successfully with \(existingData.count) entries.")
        } else {
            print("Failed to encode vomiting data array.")
        }

        saveAlertMessage = "Data saved successfully!"
        showingSaveAlert = true
        print("Save button tapped")
    }


    private func loadVomitingData() -> [VomitingData] {
        guard let savedData = UserDefaults.standard.data(forKey: "VomitingDataArray"),
              let decodedData = try? JSONDecoder().decode([VomitingData].self, from: savedData) else {
            return []
        }
        return decodedData
    }

    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    

    private func loadImage() {
        guard let inputImage = inputImage else { return }
        displayImage = Image(uiImage: inputImage)
        print("Load image function called")
    }
}

struct VomitingView_Previews: PreviewProvider {
    static var previews: some View {
        VomitingView()
    }
}

