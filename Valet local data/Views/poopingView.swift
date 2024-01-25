
import SwiftUI
import WidgetKit

struct PoopingView: View {
    @State private var poopingData = PoopingData()
    @State private var datePickerDate: Date = Date()
    @State private var showingSaveConfirmation = false
    @State private var showingConsistencyAlert = false
    @State private var temporaryConsistencyComment = ""
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker(
                    "Select Date and Time",
                    selection: $datePickerDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(WheelDatePickerStyle())
                .onChange(of: datePickerDate) { newValue in
                    poopingData.lastPoopedDateTime = newValue
                }
                
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
                
                HStack {
                    Spacer()
                    Button("Save") {
                        PoopingDataManager.shared.savePoopingData(poopingData)
                        WidgetCenter.shared.reloadAllTimelines()
                        showingSaveConfirmation = true
                        
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    Spacer()
                    Button("Log Current Poop") {
                        PoopingDataManager.shared.logCurrentPoopingData()
                        showingSaveConfirmation = true
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }
                .padding(.vertical)
            }
            .onAppear {
                if let loadedData = PoopingDataManager.shared.loadFromUserDefaults() {
                    poopingData = loadedData
                    datePickerDate = loadedData.lastPoopedDateTime ?? Date()
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
        }}


class PoopingDataManager {
    static let shared = PoopingDataManager()
    private let sharedUserDefaults = UserDefaults(suiteName: "group.valet.local.data")
    
    private init() {}
    
    func logCurrentPoopingData() {
        let newPoopingData = PoopingData(
            lastPoopedDateTime: Date(), // Current time
            consist: .regular,         // Consistency set to regular
            color: ""                  // Empty color
        )
        savePoopingData(newPoopingData)
    }
    
    func savePoopingData(_ data: PoopingData) {
        if let encoded = try? JSONEncoder().encode(data) {
            sharedUserDefaults?.set(encoded, forKey: "PoopingData")
            WidgetCenter.shared.reloadAllTimelines()
        } else {
            print("Failed to encode PoopingData")
        }
    }
    func loadFromUserDefaults() -> PoopingData? {
            if let savedData = sharedUserDefaults?.data(forKey: "PoopingData") {
                let decoder = JSONDecoder()
                if let loadedRecord = try? decoder.decode(PoopingData.self, from: savedData) {
                    return loadedRecord
                }
            }
            return nil
        }
    
  
}
