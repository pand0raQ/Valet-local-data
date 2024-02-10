import SwiftUI
import WidgetKit

struct PoopingView: View {
    @State private var poopingData = PoopingData()
    @State private var datePickerDate: Date = Date()
    @State private var showingSaveConfirmation = false
    @State private var showingConsistencyAlert = false
    @State private var temporaryConsistencyComment = ""
    @State private var viewMode: Int = 0 // Add this state variable to toggle between views

    var body: some View {
        NavigationView {
            Form {
                DatePicker(
                    "",
                    selection: $datePickerDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(WheelDatePickerStyle())
                .onChange(of: datePickerDate) { newValue in
                    poopingData.lastPoopedDateTime = newValue
                }
                
                // Add a segmented picker to switch between normal and detailed views
                Picker("View Mode", selection: $viewMode) {
                    Text("Normal").tag(0)
                    Text("Detailed").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.vertical)
                
                // Only show the following sections if viewMode is 1 (detailed view)
                if viewMode == 1 {
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
                            showingConsistencyAlert = true
                        }
                    }
                    TextField("Color", text: $poopingData.color)
                }
                
                HStack {
                    Spacer()
                    Button("Save") {
                        poopingData.isDetailed = viewMode == 1

                        PoopingDataManager.shared.savePoopingData(poopingData)
                        WidgetCenter.shared.reloadAllTimelines()
                        showingSaveConfirmation = true
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    Spacer()
                }
                .padding(.vertical)
            }
            .onAppear {
                let allPoopingData = PoopingDataManager.shared.loadAllPoopingData()
                if let mostRecentData = allPoopingData.last {
                    poopingData = mostRecentData
                    datePickerDate = mostRecentData.lastPoopedDateTime ?? Date()
                }
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
    private func resetForm() {
        poopingData = PoopingData()
        datePickerDate = Date()
    }
}




class PoopingDataManager {
    static let shared = PoopingDataManager()
    private let sharedUserDefaults = UserDefaults(suiteName: "group.valet.local.data")

    func savePoopingData(_ newData: PoopingData) {
            print("Attempting to save new pooping data...")

            // Load existing data
            var existingData = loadAllPoopingData()
            print("Currently have \(existingData.count) pooping log(s) before saving.")

            // Append new data
            existingData.append(newData)

            // Encode and save the updated array
            do {
                let encoded = try JSONEncoder().encode(existingData)
                sharedUserDefaults?.set(encoded, forKey: "PoopingDataArray")
                print("Successfully saved new pooping data. Total logs: \(existingData.count)")
            } catch {
                print("Failed to encode PoopingData with error: \(error)")
            }

            // Optionally, you could also print the newly saved data for debugging purposes
            if let savedData = sharedUserDefaults?.data(forKey: "PoopingDataArray"), let decodedData = try? JSONDecoder().decode([PoopingData].self, from: savedData) {
                print("Decoded saved pooping data: \(decodedData)")
            } else {
                print("Could not fetch saved pooping data after saving.")
            }
        }

        // Make sure the loadAllPoopingData() method is correctly implemented as well.
    

    func loadAllPoopingData() -> [PoopingData] {
        guard let savedData = sharedUserDefaults?.data(forKey: "PoopingDataArray"),
              let decodedData = try? JSONDecoder().decode([PoopingData].self, from: savedData) else {
            return []
        }
        return decodedData
    }
}


