

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
                            poopingLogDates: Set(), // Assuming you need to provide a set of dates for pooping logs
                            vomitLogDates: Set(), // Assuming you need to provide a set of dates for vomit logs
                            appetiteLogDates: Set(), // Assuming you need to provide a set for appetite logs
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
    var getLogTypes: (Date) -> [LogType]



    var body: some View {
   
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
          
          // Example existence checks
          if hasPoopLogs(for: date) {
              types.append(.poop)
          }
          if hasVomitLogs(for: date) {
              types.append(.vomit)
          }
          if hasAppetiteLogs(for: date) {
              types.append(.appetite)
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


    
    private func fetchLogs<T: Codable>(for type: LogType) -> [T] {
        print("Fetching logs for type: \(type)")
        
        let key: String
        var userDefaults: UserDefaults?
        
        switch type {
        case .poop:
            key = "PoopingDataArray"
            userDefaults = UserDefaults(suiteName: "group.valet.local.data")
        case .vomit:
            key = "VomitingDataArray"
            userDefaults = .standard
        case .appetite:
            key = "DogAppetiteRecordsArray"
            // Assuming this is in the standard UserDefaults
            userDefaults = .standard
        case .allergies, .grooming, .medication:
            key = "SomeKeyBasedOnType"
            // Decide based on type, for example:
            userDefaults = type == .allergies ? .standard : UserDefaults(suiteName: "group.valet.local.data")
        default:
            print("Log type not found")
            return []
        }
        
        guard let defaults = userDefaults else {
            print("UserDefaults not found for type: \(type)")
            return []
        }
        
        // Decode and return the logs for the specified key
        let decoder = JSONDecoder()
        if let savedData = defaults.data(forKey: key) {
            do {
                let decodedArray = try decoder.decode([T].self, from: savedData)
                return decodedArray
            } catch {
                print("Error decoding data for key \(key): \(error)")
            }
        } else {
            print("No data found for key: \(key)")
        }
        
        return [] // Return an empty array if no data is found or if an error occurs
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

        // Assume similar conversion for other log types and add them to allLogs

        // Filter logs to include only those that match the selectedDate
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




