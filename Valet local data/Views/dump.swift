//
//import SwiftUI
//
//struct CalendarView: View {
//    
//    @State private var selectedDate = Date()
//    @State private var showingFilter = false
//    @State private var selectedLogTypes: Set<LogType> = [.poop, .vomit, .appetite, .allergies, .grooming, .medication ]
//    private var calendar = Calendar.current
//    @State private var selectedCategories: [CategoryType] = [] // Initialize as needed
//    let categories: [CategoryType] = []
//
// 
//    
//
//    
//    
//    
//    
//    
//    var body: some View {
//        
//        
//        NavigationView {
//            
//            VStack {
//                Text("nav view text")
//                CustomCalendar(selectedDate: $selectedDate, calendar: calendar)
//                    .onChange(of: selectedDate) { newValue in
//                        print("Selected Date changed to: \(newValue)")
//                        loadData()  // Call loadData to fetch logs for the new date
//                    }
//                
//                List(filteredLogs(for: selectedDate), id: \.self) { log in
//                    VStack(alignment: .leading) {
//                        Text(log.description)
//                            .font(.headline)
//                        Text("Date: \(log.date.formatted())")
//                            .font(.subheadline)
//                    }
//                }
//                
//                Spacer()
//            }
//            .onAppear {
//                print("CalendarView appeared")
//                
//                loadData()  // Load data when the view appears
//            }
//        }
//          .navigationBarTitle("Dog's Health Calendar")
//          .navigationBarItems(trailing: Button("Filter") {
//              showingFilter = true
//          })
//
//          .sheet(isPresented: $showingFilter) {
//              
//              NavigationView {
//                  init(selectedLogTypes: Binding<Set<LogType>>, selectedCategories: Binding<[CategoryType]>, categories: [CategoryType]) {
//                      _selectedLogTypes = selectedLogTypes
//                      _selectedCategories = selectedCategories
//                      self.categories = categories
//                  }
//
//                  FilterView(selectedLogTypes: $selectedLogTypes, selectedCategories: $selectedCategories, categories: categories)
//                      .navigationBarTitle("Filter Logs", displayMode: .inline)
//                      .navigationBarItems(leading: Button("Cancel") {
//                          showingFilter = false
//                      }, trailing: Button("Apply") {
//                          // Apply filter logic or dismiss view
//                          showingFilter = false
//                      })
//              }
//          }
//      }
//  }
//
//    
//    
//    
//        
//    
//
//struct CustomCalendar: View {
//    @Binding var selectedDate: Date
//    let calendar: Calendar
//    private var month: DateInterval {
//        calendar.dateInterval(of: .month, for: selectedDate)!
//    }
//    
//    var body: some View {
//        VStack {
//            Text("cal view  text")
//            
//            HStack {
//                Text(month.start, formatter: monthAndYearFormatter)
//                Spacer()
//                Button(action: previousMonth) {
//                    Image(systemName: "chevron.left")
//                }
//                Button(action: nextMonth) {
//                    Image(systemName: "chevron.right")
//                }
//            }
//            .padding()
//            
//            Divider()
//            
//            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 10) {
//                ForEach(daysInMonth(), id: \.self) { day in
//                    Button(action: { self.selectedDate = day }) {
//                        Text("\(calendar.component(.day, from: day))")
//                            .frame(width: 30, height: 30)
//                            .background(calendar.isDate(day, inSameDayAs: selectedDate) ? Color.blue : Color.clear)
//                            .foregroundColor(calendar.isDateInToday(day) ? .red : .black)
//                            .cornerRadius(15)
//                    }
//                }
//            }
//        }
//        .onAppear {
//            print("CustomCalendar appeared")
//        }
//    }
//    
//    private var monthAndYearFormatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMMM yyyy"
//        return formatter
//    }
//    
//    private func previousMonth() {
//        if let newMonth = calendar.date(byAdding: .month, value: -1, to: month.start) {
//            selectedDate = newMonth
//        }
//    }
//    
//    private func nextMonth() {
//        if let newMonth = calendar.date(byAdding: .month, value: 1, to: month.start) {
//            selectedDate = newMonth
//        }
//    }
//    
//    private func daysInMonth() -> [Date] {
//        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate) else {
//            print("Failed to generate month interval")
//            return []
//        }
//        let dates = calendar.generateDates(inside: monthInterval, matching: DateComponents(hour: 0, minute: 0, second: 0))
//        print("Generated dates in month: \(dates)")
//        return dates
//    }
//}
//
//
//extension CalendarView {
// 
//    
//    
//    private func fetchLogs<T: Codable>(for type: LogType) -> [T] {
//        print("Fetching logs for type: \(type)")
//
//        
//        var keys: [String]
//        
//        switch type {
//        case .poop:
//                // Check if the data manager returns a single object or an array
//                if let poopingData = PoopingDataManager.shared.loadFromUserDefaults() as? T {
//                    return [poopingData]  // Return as a single element array
//                } else if let poopingDataArray = PoopingDataManager.shared.loadFromUserDefaults() as? [T] {
//                    return poopingDataArray  // Return the array
//                }
//                return []
//            
//        case .vomit:
//            keys = ["VomitingData"]
//        case .appetite:
//            keys = ["DogAppetiteRecord"]
//        case .allergies:
//            keys =  ["RashDataEntries", "ScratchingIntensityDataEntries",
//                     "EyesDataEntries"]
//        case .grooming:
//            keys = ["groomingActivities"]
//        case .medication:
//                keys = ["SavedMedications"]
//            
//        default:
//            return []
//        }
//        
//            let decoder = JSONDecoder()
//            for key in keys {
//                print("Fetching logs for key: \(key)")
//
//                if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
//                    print("Saved data found for key: \(key)")
//
//                    if let singleObject = try? decoder.decode(T.self, from: savedData) {
//                        return [singleObject]  // Return as a single element array
//                    } else if let arrayObject = try? decoder.decode([T].self, from: savedData) {
//                        return arrayObject  // Return the decoded array
//                    } else {
//                        print("Error decoding data for key \(key): Could not decode to either single object or array.")
//                    }
//                }
//            }
//            return []  // Return an empty array if no data is found
//        }
//
//    private func filteredLogs(for date: Date) -> [DogLog] {
//        var allLogs = [DogLog]()
//
//        // Fetch and convert PoopingData logs
//        let poopingLogs: [PoopingData] = fetchLogs(for: .poop)
//           allLogs += poopingLogs.map { convertToDogLog($0, type: .poop) }
//
//
//        // Fetch and convert VomitingData logs
//        let vomitingLogs: [VomitingData] = fetchLogs(for: .vomit)
//        allLogs += vomitingLogs.map { convertToDogLog($0, type: .vomit) }
//        
//        let appetiteLogs: [DogAppetiteRecord] = fetchLogs(for: .appetite)
//        allLogs += appetiteLogs.map { convertToDogLog($0, type: .appetite) }
//        
//        let allergiesLoags: [DogAppetiteRecord] = fetchLogs(for: .allergies)
//        allLogs += appetiteLogs.map { convertToDogLog($0, type: .allergies) }
//        
//        let rashLogs: [RashData] = fetchLogs(for: .allergies)  // Assuming .allergies for RashData
//         allLogs += rashLogs.map { convertToDogLog($0, type: .allergies) }
//
//         let scratchingLogs: [ScratchingIntensityEntry] = fetchLogs(for: .allergies)  // Adjust LogType as needed
//         allLogs += scratchingLogs.map { convertToDogLog($0, type: .allergies) }
//
//         let eyesLogs: [EyesData] = fetchLogs(for: .allergies)  // Adjust LogType as needed
//         allLogs += eyesLogs.map { convertToDogLog($0, type: .allergies) }
//
//         // Fetch and convert Grooming logs
//        let groomingLogs: [GroomingActivity] = fetchLogs(for: .grooming).filter { $0.lastCompletedDate != nil }
//           allLogs += groomingLogs.map { convertToDogLog($0, type: .grooming) }
//
//        
//        let medicationLogs: [AppModels.DogMedicationRecord] = fetchLogs(for: .medication)
//            for medicationLog in medicationLogs {
//                let times = medicationLog.dailyTimes ?? [] + (medicationLog.irregularTimes ?? [])
//                for time in times where time.administered {
//                    if Calendar.current.isDate(time.date, inSameDayAs: date) {
//                        let log = DogLog(type: .medication, date: time.date, description: "Medication administered: \(medicationLog.medicationName)")
//                        allLogs.append(log)
//                    }
//                }
//            }
//        
//        
//        // Fetch and convert other types of logs in a similar manner
//
//        // Filter logs based on the selected date and log types
//        return allLogs.filter { log in
//            Calendar.current.isDate(log.date, inSameDayAs: date) && selectedLogTypes.contains(log.type)
//        }
//    }
//
//    private func convertToDogLog<T>(_ data: T, type: LogType) -> DogLog {
//        var description = ""
//        var date: Date = Date()  // Initialize date with a default value such as the current date
//
//        switch type {
//        case .poop:
//            if let poopingData = data as? PoopingData {
//                date = poopingData.lastPoopedDateTime ?? Date()
//                description = "Pooping: Consistency - \(poopingData.consist.rawValue), Color: \(poopingData.color)"
//            } else {
//                // Here, handle the error scenario, don't try to fetch or return anything else
//                description = "Invalid Pooping Data"
//            }
//            return DogLog(type: type, date: date, description: description)
//            
//        case .vomit:
//            if let vomitingData = data as? VomitingData {
//                date = vomitingData.lastVomitDateTime
//                description = "Vomiting: Last occurred on \(vomitingData.lastVomitDateTime.formatted())"
//            } else {
//                return DogLog(type: type, date: Date(), description: "Invalid Vomiting Data")
//            }
//        case .appetite:
//                if let appetiteData = data as? DogAppetiteRecord {
//                    description = "Appetite Record: Food Amount - \(appetiteData.foodAmount), Food Brand - \(appetiteData.foodBrand), Water Intake - \(appetiteData.waterIntake)"
//                    // Use default date or a specific placeholder date
//                } else {
//                    return DogLog(type: type, date: date, description: description)
//                }
//        case .allergies:
//                if let rashData = data as? RashData {
//                    date = rashData.dater
//                    description = "Rash observed on \(date.formatted())"
//                } else if let scratchingData = data as? ScratchingIntensityEntry {
//                    date = scratchingData.datescr
//                    description = "Scratching Intensity: \(scratchingData.intensity) on \(date.formatted())"
//                } else if let eyesData = data as? EyesData {
//                    date = eyesData.dateeye
//                    description = "Eyes issue with intensity: \(eyesData.intensity) on \(date.formatted())"
//                } else {
//                    return DogLog(type: type, date: Date(), description: "Invalid Allergy Data")
//                }
//        case .grooming:
//                if let groomingData = data as? GroomingActivity {
//                    date = groomingData.lastCompletedDate ?? Date() // Use the last completed date or a default date
//                    description = "Grooming Activity: \(groomingData.activityName), Last Completed: \(groomingData.lastCompletedDate)"
//                } else {
//                    return DogLog(type: type, date: Date(), description: "Invalid Grooming Data")
//                }
//            
//        case .medication:
//               if let medicationData = data as? AppModels.DogMedicationRecord {
//                   // Example: Assuming you want to log each administration time
//                   for time in medicationData.dailyTimes ?? [] {
//                       if time.administered {
//                           return DogLog(type: type, date: time.date, description: "Medication administered: \(medicationData.medicationName)")
//                       }
//                   }
//                   for time in medicationData.irregularTimes ?? [] {
//                       if time.administered {
//                           return DogLog(type: type, date: time.date, description: "Medication administered: \(medicationData.medicationName)")
//                       }
//                   }
//                   description = "No medication administered" // or some default message
//               } else {
//                   return DogLog(type: type, date: Date(), description: "Invalid Medication Data")
//               }
//
//            
//        default:
//            date = Date()
//            description = "Unrecognized log type"
//        }
//
//        return DogLog(type: type, date: date, description: description)
//    }
//
//    
//    
//    
//    
//    private func numberOfDaysInMonth() -> Int {
//        let range = calendar.range(of: .day, in: .month, for: selectedDate)
//        return range?.count ?? 30
//    }
//    
//    private func dayOfMonth(for index: Int) -> Int {
//        let startOfMonth = calendar.startOfMonth(for: selectedDate)
//        let date = calendar.date(byAdding: .day, value: index, to: startOfMonth)!
//        let day = calendar.component(.day, from: date)
//        return day
//    }
//    
//    private func isToday(_ index: Int) -> Bool {
//        let dayOfMonth = self.dayOfMonth(for: index)
//        return calendar.isDateInToday(calendar.date(bySetting: .day, value: dayOfMonth, of: selectedDate)!)
//    }
//    
//
//    
//}
//
//extension Calendar {
//    func startOfMonth(for date: Date) -> Date {
//        let components = dateComponents([.year, .month], from: date)
//        return self.date(from: components)!
//    }
//    
//    func generateDates(inside interval: DateInterval, matching components: DateComponents) -> [Date] {
//          var dates: [Date] = []
//          var current = interval.start
//          while current < interval.end {
//              dates.append(current)
//              current = self.date(byAdding: components, to: current)!
//          }
//          return dates
//      }
//  }
//
//
//
//
//
//
//private func loadData() {
//    print("Starting to load data...")
//    
//    var allLogs = [DogLog]()
//    
//    // Fetch PoopingData
//    let poopingLogs: [PoopingData] = fetchLogs(for: .poop)
//    print("Fetched Pooping Logs: \(poopingLogs)")
//    
//    // Fetch VomitingData
//    let vomitingLogs: [VomitingData] = fetchLogs(for: .vomit)
//    print("Fetched Vomiting Logs: \(vomitingLogs)")
//    
//    // Fetch DogAppetiteRecord
//    let appetiteLogs: [DogAppetiteRecord] = fetchLogs(for: .appetite)
//    print("Fetched DogAppetiteRecord Logs: \(appetiteLogs)")
//    
//    // Fetch allergy-related data separately for each type
//    let rashLogs: [RashData] = fetchLogs(for: .allergies)
//    print("Fetched Rash Logs: \(rashLogs)")
//    let scratchingLogs: [ScratchingIntensityEntry] = fetchLogs(for: .allergies)
//    print("Fetched Scratching Intensity Logs: \(scratchingLogs)")
//    let eyesLogs: [EyesData] = fetchLogs(for: .allergies)
//    print("Fetched Eyes Logs: \(eyesLogs)")
//    
//    // Fetch GroomingActivity
//    let groomingLogs: [GroomingActivity] = fetchLogs(for: .grooming)
//    print("Fetched Grooming Logs: \(groomingLogs)")
//    
//    // Fetch Medication logs
//    let medicationLogs: [AppModels.DogMedicationRecord] = fetchLogs(for: .medication)
//    print("Fetched Medication Logs: \(medicationLogs)")
//    
//    medicationLogs.forEach { medicationLog in
//        if medicationLog.wasAdministered(on: selectedDate) {
//            let log = DogLog(type: .medication, date: selectedDate, description: "Medication administered: \(medicationLog.medicationName)")
//            allLogs.append(log)
//        }
//    }
//    print("Fetched Medication Logs: \(medicationLogs)")
//    
//    // Combine and store all fetched logs
//    // Update the state with allLogs
//}
//



//struct CustomCalendar: View {
//    @Binding var selectedDate: Date
//    let calendar: Calendar
//    private var month: DateInterval {
//        calendar.dateInterval(of: .month, for: selectedDate)!
//    }
//    
//    var body: some View {
//        VStack {
//            Text("cal view  text")
//            
//            HStack {
//                Text(month.start, formatter: monthAndYearFormatter)
//                Spacer()
//                Button(action: previousMonth) {
//                    Image(systemName: "chevron.left")
//                }
//                Button(action: nextMonth) {
//                    Image(systemName: "chevron.right")
//                }
//            }
//            .padding()
//            
//            Divider()
//            
//            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 10) {
//                ForEach(daysInMonth(), id: \.self) { day in
//                    Button(action: { self.selectedDate = day }) {
//                        Text("\(calendar.component(.day, from: day))")
//                            .frame(width: 30, height: 30)
//                            .background(calendar.isDate(day, inSameDayAs: selectedDate) ? Color.blue : Color.clear)
//                            .foregroundColor(calendar.isDateInToday(day) ? .red : .black)
//                            .cornerRadius(15)
//                    }
//                }
//            }
//        }
//        .onAppear {
//            print("CustomCalendar appeared")
//        }
//    }
//    
//    private var monthAndYearFormatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMMM yyyy"
//        return formatter
//    }
//    
//    private func previousMonth() {
//        if let newMonth = calendar.date(byAdding: .month, value: -1, to: month.start) {
//            selectedDate = newMonth
//        }
//    }
//    
//    private func nextMonth() {
//        if let newMonth = calendar.date(byAdding: .month, value: 1, to: month.start) {
//            selectedDate = newMonth
//        }
//    }
//    
//    private func daysInMonth() -> [Date] {
//        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate) else {
//            print("Failed to generate month interval")
//            return []
//        }
//        let dates = calendar.generateDates(inside: monthInterval, matching: DateComponents(hour: 0, minute: 0, second: 0))
//        print("Generated dates in month: \(dates)")
//        return dates
//    }
//}
