

import SwiftUI
import PhotosUI

struct CenteredButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}

extension View {
    func centeredButtonStyle() -> some View {
        self.modifier(CenteredButtonStyle())
    }
}



struct AllergiesView: View {
    @State private var rashDate = Date()
    @State private var rashIntensity = "Medium"
    @State private var showRashImagePicker = false
    @State private var rashImage: UIImage?
    @State private var rashDataEntries: [RashData] = []
    
    @State private var scratchingIntensity = "Medium"
    @State private var scratchingIntensityEntries: [ScratchingIntensityEntry] = []
    @State private var scratchingIntensityDate = Date()

    
    @State private var eyesDate = Date()
    @State private var eyesIntensity = "Medium"
    @State private var showEyesImagePicker = false
    @State private var eyesImage: UIImage?
    @State private var eyesDataEntries: [EyesData] = []
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var expandedSection: ExpandedSection? = nil
    
    
    enum ExpandedSection {
        case rash, scratchingIntensity, eyes, history
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Rash Section
                Section(header: sectionHeader(title: "Rash", section: .rash)) {
                    if expandedSection == .rash {
                        DatePicker("Date Noticed", selection: $rashDate, displayedComponents: .date)
                        Button("Take or Choose Picture") {
                            showRashImagePicker = true
                        }
                        Button("Save") {
                            saveRashDataEntry()
                            
                        }
                        .padding()
                        .buttonStyle(.borderedProminent)
                        .centeredButtonStyle()

                        .tint(.green)
                        
                        if let rashImage = rashImage {
                            Image(uiImage: rashImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                        }
                        
                    }
                   
                }
                
                
                // Scratching Intensity Section
                Section(header: sectionHeader(title: "Scratching Intensity", section: .scratchingIntensity)) {
                    if expandedSection == .scratchingIntensity {
                        DatePicker("Entry date", selection: $scratchingIntensityDate, displayedComponents: .date)
                        Picker("Intensity", selection: $scratchingIntensity) {
                            Text("High").tag("High")
                            Text("Medium").tag("Medium")
                            Text("Low").tag("Low")
                        }.pickerStyle(SegmentedPickerStyle())
                        Button("Save") {
                            saveScratchingIntensityDataEntry()
                        }
                        .padding()
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                        .centeredButtonStyle()

                    }
                  
                }
                
                // Eyes Section
                Section(header: sectionHeader(title: "Eyes", section: .eyes)) {
                    if expandedSection == .eyes {
                        
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
                        Button("Save") {
                            saveEyesDataEntry()
                        }
                        .centeredButtonStyle()
                        .padding()
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                    }
                  
                }
                
                //history section
                Section(header: sectionHeader(title: "History", section: .history)) {
                    if expandedSection == .history {
                        Text("Rash History:")
                        ForEach(rashDataEntries) { entry in
                            VStack {
                                Text("Date: \(entry.dater, formatter: DateFormatter.shortDate)")
                                if let imageData = entry.imageData, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                }
                            }
                        }
                        
                        Text("Scratching Intensity History:")
                        ForEach(scratchingIntensityEntries) { entry in
                            Text("Intensity: \(entry.intensity)")
                        }
                        
                        Text("Eyes History:")
                        ForEach(eyesDataEntries) { entry in
                            VStack {
                                Text("Date: \(entry.dateeye, formatter: DateFormatter.shortDate)")
                                Text("Intensity: \(entry.intensity)")
                                if let imageData = entry.imageData, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                }
                            }
                        }
                    }
                }
                
            }
        
                   .sheet(isPresented: $showRashImagePicker) {
                       ImagePickerAllergy(image: $rashImage)
                   }
                   .sheet(isPresented: $showEyesImagePicker) {
                       ImagePickerAllergy(image: $eyesImage)
                   }
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Success"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

    
    
    // Save Functions

    extension AllergiesView {
        
        private func sectionHeader(title: String, section: ExpandedSection) -> some View {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: expandedSection == section ? "chevron.down" : "chevron.right")
            }
            .contentShape(Rectangle())
            .onTapGesture {
                toggleSection(section)
            }
        }

        private func toggleSection(_ section: ExpandedSection) {
            if expandedSection == section {
        // Collapse the section and reset its data
        expandedSection = nil
        resetSectionData(section)
        } else {
        // Expand the tapped section
        expandedSection = section
        }
        }
        private func resetSectionData(_ section: ExpandedSection) {
        switch section {
        case .rash:
        rashDate = Date()
        rashIntensity = "Medium"
        rashImage = nil
        case .scratchingIntensity:
        scratchingIntensity = "Medium"
        case .eyes:
        eyesDate = Date()
        eyesIntensity = "Medium"
        eyesImage = nil
        case .history:
        // Resetting history might not be necessary, depends on your use case
        break
        }
        }
        
        
        private func saveRashDataEntry() {
              let imageData = rashImage?.jpegData(compressionQuality: 0.5)
              let newRashData = RashData(dater: rashDate, imageData: imageData)
              rashDataEntries.append(newRashData)
              saveRashDataToUserDefaults()

              alertMessage = "Rash info saved"
              showAlert = true
          }
          
          private func saveScratchingIntensityDataEntry() {
              let newIntensityEntry = ScratchingIntensityEntry(intensity: scratchingIntensity, datescr: scratchingIntensityDate)
              scratchingIntensityEntries.append(newIntensityEntry)
              saveScratchingIntensityDataToUserDefaults()

              alertMessage = "Scratching Intensity saved"
              showAlert = true
          }
          
          private func saveEyesDataEntry() {
              let imageData = eyesImage?.jpegData(compressionQuality: 0.5)
              let newEyesData = EyesData(id: UUID(), dateeye: eyesDate, intensity: eyesIntensity, imageData: imageData)
              eyesDataEntries.append(newEyesData)
              saveEyesDataToUserDefaults()

              alertMessage = "Problem with eyes saved"
              showAlert = true
          }
        
        
        // UserDefaults Persistence
        private func saveRashDataToUserDefaults() {
            if let data = try? JSONEncoder().encode(rashDataEntries) {
                UserDefaults.standard.set(data, forKey: "RashDataEntries")
            }
        }
        
        private func saveScratchingIntensityDataToUserDefaults() {
            if let data = try? JSONEncoder().encode(scratchingIntensityEntries) {
                UserDefaults.standard.set(data, forKey: "ScratchingIntensityDataEntries")
            }
        }
        
        private func saveEyesDataToUserDefaults() {
            if let data = try? JSONEncoder().encode(eyesDataEntries) {
                UserDefaults.standard.set(data, forKey: "EyesDataEntries")
            }
        }
        
        private func loadRashDataEntries() {
            if let data = UserDefaults.standard.data(forKey: "RashDataEntries"),
               let savedEntries = try? JSONDecoder().decode([RashData].self, from: data) {
                rashDataEntries = savedEntries
            }
        }
        
        private func loadScratchingIntensityDataEntries() {
            if let data = UserDefaults.standard.data(forKey: "ScratchingIntensityDataEntries"),
               let savedEntries = try? JSONDecoder().decode([ScratchingIntensityEntry].self, from: data) {
                scratchingIntensityEntries = savedEntries
            }
        }
        
        private func loadEyesDataEntries() {
            if let data = UserDefaults.standard.data(forKey: "EyesDataEntries"),
               let savedEntries = try? JSONDecoder().decode([EyesData].self, from: data) {
                eyesDataEntries = savedEntries
            }
        }
        struct CenteredButtonStyle: ViewModifier {
            func body(content: Content) -> some View {
                HStack {
                    Spacer()
                    content
                    Spacer()
                }
            }
        }
        
    }

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
}




