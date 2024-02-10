
import SwiftUI
extension View {
    func debugPrint(_ value: Any) -> some View {
        print(value)
        return EmptyView()
    }
}

struct CalendarView: View {
    @State private var selectedDate = Date()
    @State private var showingSheet = false
    
    @State private var showingFilter = false
    @State private var selectedLogTypes: Set<LogType> = [.poop, .vomit, .appetite, .allergies, .grooming, .medication]
    
    @State private var selectedCategories: [CategoryType] = [] // Assuming CategoryType is defined elsewhere
    let categories: [CategoryType] = [] // Assuming you will fill this with actual categories
    @State private var currentLogTypes: [LogType] = []

    
    func loadData() {
       print("Starting to load data...")
       
       var allLogs = [DogLog]()
       
       // Fetch PoopingData
       let poopingLogs: [PoopingData] = fetchLogs(for: .poop)
       print("Fetched Pooping Logs: \(poopingLogs)")
       
       // Fetch VomitingData
       let vomitingLogs: [VomitingData] = fetchLogs(for: .vomit)
       print("Fetched Vomiting Logs: \(vomitingLogs)")
       
       // Fetch DogAppetiteRecord
       let appetiteLogs: [DogAppetiteRecord] = fetchLogs(for: .appetite)
       print("Fetched DogAppetiteRecord Logs: \(appetiteLogs)")
       
       // Fetch allergy-related data separately for each type
       let rashLogs: [RashData] = fetchLogs(for: .allergies)
       print("Fetched Rash Logs: \(rashLogs)")
       let scratchingLogs: [ScratchingIntensityEntry] = fetchLogs(for: .allergies)
       print("Fetched Scratching Intensity Logs: \(scratchingLogs)")
       let eyesLogs: [EyesData] = fetchLogs(for: .allergies)
       print("Fetched Eyes Logs: \(eyesLogs)")
       
       // Fetch GroomingActivity
       let groomingLogs: [GroomingActivity] = fetchLogs(for: .grooming)
       print("Fetched Grooming Logs: \(groomingLogs)")
       
       // Fetch Medication logs
       let medicationLogs: [AppModels.DogMedicationRecord] = fetchLogs(for: .medication)
       print("Fetched Medication Logs: \(medicationLogs)")
       
       medicationLogs.forEach { medicationLog in
           if medicationLog.wasAdministered(on: selectedDate) {
               let log = DogLog(type: .medication, date: selectedDate, description: "Medication administered: \(medicationLog.medicationName)")
               allLogs.append(log)
           }
       }
       print("Fetched Medication Logs: \(medicationLogs)")
       
        DispatchQueue.main.async {
               // Update UI elements or state variables here
           }
   }
    
    var body: some View {
            NavigationView {
                VStack(spacing: 0) {
                    CustomCalendar(
                            selectedDate: $selectedDate,
                            showingSheet: $showingSheet,
                            poopingLogDates: Set(),
                            vomitLogDates: Set(),
                            appetiteLogDates: Set(),
                            allergiesLogDates: Set(),
                            medLogDated : Set(),
                            getLogTypes: logTypes
                        )
                    .onChange(of: selectedDate) { newDate in
                           self.currentLogTypes = logTypes(for: newDate)
                           loadData() // Assuming loadData is correctly fetching and updating the view
                       }
                        .edgesIgnoringSafeArea(.all)
                }
              //  .background(Color.red) // Apply to VStack

                .navigationBarTitle("Dog's Health Calendar", displayMode: .inline)
              //  .background(Color.blue) // Apply to NavigationView

            
                .sheet(isPresented: $showingSheet) {
                    // Your sheet content goes here. For example, a detailed view for the selected date.
                    Text("Details for \(selectedDate.formatted())") // Placeholder for your actual sheet content
                    DetailsView(logs: filteredLogs(for: selectedDate))

                }
            }
            .onAppear {
                            // Call loadData() here to ensure data is loaded when the view appears
                            loadData()
                        }
            .edgesIgnoringSafeArea(.top)
        }
    
        
    }


struct CustomCalendar: View {
    
    @Binding var selectedDate: Date
    @Binding var showingSheet: Bool // This line is added to accept the binding from the parent view
    let calendar = Calendar.current
    var poopingLogDates: Set<Date>
    var vomitLogDates: Set<Date>
    var appetiteLogDates: Set<Date>
    var allergiesLogDates: Set<Date>
    var medLogDated: Set<Date>

    
    var getLogTypes: (Date) -> [LogType]



    var body: some View {
   //month selector part
            HStack {
                Button(action: { self.moveMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text("\(monthYearText(from: selectedDate))")
                    .font(.headline)
                Spacer()
                Button(action: { self.moveMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()
    //month selector part

        
        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7), spacing: 0) {
            ForEach(daysInMonth(for: selectedDate), id: \.self) { date in
                VStack {
                    Text("\(date, formatter: dayFormatter)")
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 5)
                    VStack {
                        ForEach(getLogTypes(date), id: \.self) { logType in // Use `date` instead of `selectedDate`
                            Text(logType.emoji)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Calendar.current.isDate(date, inSameDayAs: selectedDate) ? Color.blue : Color.clear)
                .cornerRadius(8)
                .onTapGesture {
                    self.selectedDate = date
                    self.showingSheet = true
                }
            }

            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        }
       
    
    
    private func monthYearText(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func daysInMonth(for date: Date) -> [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: date) else { return [] }
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        
        return range.compactMap { day -> Date? in
            return calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
    }
    
    private func moveMonth(by months: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: months, to: selectedDate) {
            selectedDate = newMonth
        }
    }
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
}

struct DetailsView: View {
    var logs: [DogLog] // Use your actual data model here

    var body: some View {
        List(logs, id: \.self) { log in // Updated to use \.self for simplicity
            Text(log.description) // Ensure 'description' is a valid property of DogLog
        }
    }
}








extension CalendarView {
    
    func logTypes(for date: Date) -> [LogType] {
        var types: [LogType] = []
        
        let poopingLogs = PoopingDataManager.shared.loadAllPoopingData().filter { poopingData in
            guard let logDate = poopingData.lastPoopedDateTime else { return false }
            return Calendar.current.isDate(logDate, inSameDayAs: date)
        }
        
        // Determine if any log is a detailed pooping log
        for poopingLog in poopingLogs {
            if poopingLog.isDetailed {
                types.append(.detpoop)
            } else {
                types.append(.poop)
            }
        }
    
        
        if hasVomitLogs(for: date) {
            types.append(.vomit)
        }
        if hasAppetiteLogs(for: date) {
            types.append(.appetite)
        }
        if hasAllergyLogs(for: date) {
            types.append(.allergies)
        }
        
        if hasMedLogs(for: date) {
            types.append(.medication)
        }
        
        
        // Add more checks as needed
        
        return types
    }
    

    
    private func hasPoopLogs(for date: Date) -> Bool {
        // Check if the set of pooping log dates contains the given date
        return poopingLogDates.contains { logDate in
            Calendar.current.isDate(logDate, inSameDayAs: date)
        }
    }
    
    private func hasVomitLogs(for date: Date) -> Bool {
        
        return vomitingLogDates.contains { logDate in
            Calendar.current.isDate(logDate, inSameDayAs: date)
        }
    }
    
    private func hasAppetiteLogs(for date: Date) -> Bool {
        return hasAppetiteLogs.contains { logDate in
            Calendar.current.isDate(logDate, inSameDayAs: date)
        }
    }
    func hasAllergyLogs(for date: Date) -> Bool {
        return allergyLogDates.contains { logDate in
            Calendar.current.isDate(logDate, inSameDayAs: date)
        }
    }
    func hasMedLogs(for date: Date) -> Bool {
        return medLogDates.contains { logDate in
            Calendar.current.isDate(logDate, inSameDayAs: date)
        }
    }
    
    var poopingLogDates: Set<Date> {
        var dates = Set<Date>()
        
        // Assuming PoopingData has a `lastPoopedDateTime` property of type Date
        let poopingLogs: [PoopingData] = fetchLogs(for: .poop)
        for log in poopingLogs {
            if let date = log.lastPoopedDateTime {
                dates.insert(date)
            }
        }
        return dates
    }
    var vomitingLogDates: Set<Date> {
        var dates = Set<Date>()
        
        let vomitingLogs: [VomitingData] = fetchLogs(for: .vomit)
        for log in vomitingLogs {
            dates.insert(log.lastVomitDateTime)
        }
        return dates
    }
    var hasAppetiteLogs: Set<Date> {
        var dates = Set<Date>()
        
        let appetiteLogs: [DogAppetiteRecord] = fetchLogs(for: .appetite)
        for log in appetiteLogs {
            // Directly use log.lastVomitDateTime if it's non-optional
            dates.insert(log.lastEatDateTime)
        }
        return dates
    }
    var allergyLogDates: Set<Date> {
        var dates = Set<Date>()
        
        let rashLogs: [RashData] = fetchLogs(for: .allergies)
        for log in rashLogs {
            dates.insert(log.dater)
        }
        
        let scratchingLogs: [ScratchingIntensityEntry] = fetchLogs(for: .allergies)
        for log in scratchingLogs {
            dates.insert(log.datescr)
        }
        
        let eyesLogs: [EyesData] = fetchLogs(for: .allergies)
        for log in eyesLogs {
            dates.insert(log.dateeye)
        }
        
        return dates
    }
    var medLogDates: Set<Date> {
        var dates = Set<Date>()
        
        let medicationLogs: [AppModels.DogMedicationRecord] = fetchLogs(for: .medication)
        for log in medicationLogs {
            if let dailyTimes = log.dailyTimes {
                for time in dailyTimes {
                    if time.administered {
                        dates.insert(time.date)
                    }
                }
            }
            if let irregularTimes = log.irregularTimes {
                for time in irregularTimes {
                    if time.administered {
                        dates.insert(time.date)
                    }
                }
            }
        }
        
        return dates
    }

    
    
    
    private func fetchLogs<T: Codable>(for type: LogType) -> [T] {
        print("Fetching logs for type: \(type)")
        
        var keys: [String] = []
        var userDefaults: UserDefaults?
        
        switch type {
        case .poop:
            keys = ["PoopingDataArray"]
            userDefaults = UserDefaults(suiteName: "group.valet.local.data")
        case .vomit:
            keys = ["VomitingDataArray"]
            userDefaults = .standard
        case .appetite:
            keys = ["DogAppetiteRecordsArray"]
            userDefaults = .standard
        case .allergies:
            keys = ["RashDataEntries", "ScratchingIntensityDataEntries", "EyesDataEntries"]
            userDefaults = .standard
        case .medication:
            keys = ["SavedMedications"]
            userDefaults = .standard
        case .grooming :
            keys = ["SomeKeyBasedOnType"]
            userDefaults = type == .allergies ? .standard : UserDefaults(suiteName: "group.valet.local.data")
        default:
            print("Log type not found")
            return []
        }
        
        guard let defaults = userDefaults else {
            print("UserDefaults not found for type: \(type)")
            return []
        }
        
        let decoder = JSONDecoder()
        var decodedArray: [T] = []
        
        for key in keys {
            if let savedData = defaults.data(forKey: key) {
                do {
                    let decoded = try decoder.decode([T].self, from: savedData)
                    decodedArray += decoded
                } catch {
                    print("Error decoding data for key \(key): \(error)")
                }
            } else {
                print("No data found for key: \(key)")
            }
        }
        
        return decodedArray
    }
    
    
    private func filteredLogs(for selectedDate: Date) -> [DogLog] {
        var allLogs = [DogLog]()
        
        // Fetch and convert logs
        let poopingLogs: [PoopingData] = fetchLogs(for: .poop)
        allLogs += poopingLogs.map(convertPoopingDataToDogLog)
        
        let vomitingLogs: [VomitingData] = fetchLogs(for: .vomit)
        allLogs += vomitingLogs.map(convertVomitingDataToDogLog)
        
        let appetiteLogs: [DogAppetiteRecord] = fetchLogs(for: .appetite)
        allLogs += appetiteLogs.map(convertAppetiteDataToDogLog)
        
        let rashLogs: [RashData] = fetchLogs(for: .allergies)
        allLogs += rashLogs.map(convertRashDataToDogLog)
        
        let scratchingLogs: [ScratchingIntensityEntry] = fetchLogs(for: .allergies)
        allLogs += scratchingLogs.map(convertScratchingIntensityEntryToDogLog)
        
        let eyesLogs: [EyesData] = fetchLogs(for: .allergies)
        allLogs += eyesLogs.map(convertEyesDataToDogLog)
        
        let medicationLogs: [AppModels.DogMedicationRecord] = fetchLogs(for: .medication)
            allLogs.append(contentsOf: medicationLogs.flatMap(convertMedicationDataToDogLog))
        
        
        let calendar = Calendar.current
        return allLogs.filter { log in
            calendar.isDate(log.date, inSameDayAs: selectedDate)
        }
    }
    
    private func convertPoopingDataToDogLog(_ data: PoopingData) -> DogLog {
        let description = "Pooping: Consistency - \(data.consist.rawValue), Color: \(data.color)"
        let date = data.lastPoopedDateTime ?? Date()
        return DogLog(type: .poop, date: date, description: description)
    }
    
    // Conversion for VomitingData
    private func convertVomitingDataToDogLog(_ data: VomitingData) -> DogLog {
        
        let description = "Vomiting: Last occurred on \(data.lastVomitDateTime.formatted())"
        return DogLog(type: .vomit, date: data.lastVomitDateTime, description: description)
    }
    private func convertAppetiteDataToDogLog(_ data: DogAppetiteRecord) -> DogLog {
        let description = "Appetite: Food given \(data.foodAmount) mg of \(data.foodBrand), Water intake \(data.waterIntake) ml"
        return DogLog(type: .appetite, date: data.lastEatDateTime, description: description)
    }
    private func convertRashDataToDogLog(_ data: RashData) -> DogLog {
        let description = "Rash noticed - \(data.dater)"
        return DogLog(type: .allergies, date: data.dater, description: description)
    }
    
    private func convertScratchingIntensityEntryToDogLog(_ data: ScratchingIntensityEntry) -> DogLog {
        let description = "Scratching Intensity: \(data.intensity)"
        return DogLog(type: .allergies, date: data.datescr, description: description)
    }
    
    private func convertEyesDataToDogLog(_ data: EyesData) -> DogLog {
        let description = "Eyes: Redness - \(data.intensity)"
        return DogLog(type: .allergies, date: data.dateeye, description: description)
    }
    
    private func convertMedicationDataToDogLog(_ data: AppModels.DogMedicationRecord) -> [DogLog] {
        var logs: [DogLog] = [] // Initialize logs as an empty array of DogLog objects
        
        if let dailyTimes = data.dailyTimes {
            for time in dailyTimes {
                if time.administered {
                    let description = "Medication: \(data.medicationName) was administered"
                    let log = DogLog(type: .medication, date: time.date, description: description)
                    logs.append(log)
                }
            }
        }
        
        if let irregularTimes = data.irregularTimes {
            for time in irregularTimes {
                if time.administered {
                    let description = "Medication: \(data.medicationName) was administered"
                    let log = DogLog(type: .medication, date: time.date, description: description)
                    logs.append(log)
                }
            }
        }
        
        return logs
    }

    
    
}
    
    
    
extension Calendar {
 
  
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components)!
    }
    
    func generateDates(inside interval: DateInterval, matching components: DateComponents) -> [Date] {
          var dates: [Date] = []
          var current = interval.start
          while current < interval.end {
              dates.append(current)
              current = self.date(byAdding: components, to: current)!
          }
          return dates
      }
    
  }
