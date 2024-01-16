import SwiftUI
import UserNotifications


struct MedicationView: View {
    @State private var medicationName: String = ""
    @State private var dosage: String = ""
    @State private var scheduleType = "Daily"
    @State private var durationInWeeks = 1
    @State private var selectedTimes: [AppModels.NotificationTime] = [AppModels.NotificationTime(date: Date())]
    @State private var irregularDates: [AppModels.NotificationTime] = [AppModels.NotificationTime(date: Date())]
    @State private var medications: [AppModels.DogMedicationRecord] = []
    @State private var showScheduledNotifications = false
    @State private var showingDailyScheduleSuccessAlert = false
    @State private var showingIrregularScheduleSuccessAlert = false
    @State private var activeAlert: ActiveAlert?
    @State private var isAnimating: Bool = false
    @State private var forceUpdate: Bool = false // Dummy state variable to force update

    
    enum ActiveAlert: Identifiable {
        case dailyScheduleSuccess, irregularScheduleSuccess
        
        // Identifiable conformance
        var id: Int {
            self.hashValue
        }
    }
    
    private let scheduleOptions = ["Daily", "Irregular Schedule"]
    
    private func updateSelectedTimes() {
        let calendar = Calendar.current
        let now = Date()
        selectedTimes = selectedTimes.map { notificationTime in
            let timeComponents = calendar.dateComponents([.hour, .minute], from: notificationTime.date)
            var nextTime = calendar.nextDate(after: now, matching: timeComponents, matchingPolicy: .nextTimePreservingSmallerComponents) ?? notificationTime.date
            
            if nextTime <= now {
                nextTime = calendar.date(byAdding: .day, value: 1, to: nextTime)!
            }
            
            return AppModels.NotificationTime(date: nextTime)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = calendar.timeZone
        selectedTimes.forEach { time in
            print("Next occurrence: \(dateFormatter.string(from: time.date))")
        }
    }
    
    private func bindingForDatePicker(at index: Int) -> Binding<Date> {
        Binding<Date>(
            get: {
                self.irregularDates[index].date
            },
            set: { newDate in
                print("Selected new date: \(newDate)")
                self.irregularDates[index].date = newDate
                self.forceUpdate.toggle()  // Toggle the forceUpdate to refresh the view
            }
        )
    }

    
    var body: some View {
        if forceUpdate { EmptyView() }

        NavigationView {
            List {
                Section(header: Text("Medication Info")) {
                    TextField("Medication Name", text: $medicationName)
                    TextField("Dosage (e.g., 2 pills)", text: $dosage)
                }
                
                Section(header: Text("Scheduling")) {
                    Picker("Schedule Type", selection: $scheduleType) {
                        ForEach(scheduleOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if scheduleType == "Daily" {
                        Picker("Duration", selection: $durationInWeeks) {
                            ForEach(1..<53, id: \.self) { week in
                                Text("\(week) week\(week > 1 ? "s" : "")")
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        ForEach(selectedTimes.indices, id: \.self) { index in
                            DatePicker(
                                "Time \(index + 1)",
                                selection: Binding(
                                    get: { self.selectedTimes[index].date },
                                    set: { newDate in
                                        self.selectedTimes[index].date = newDate
                                        self.selectedTimes[index].timeId = UUID() // Update the identifier if necessary
                                    }
                                ),
                                displayedComponents: .hourAndMinute
                            )
                        }
                        .onDelete(perform: deleteTime)
                        
                        Image(systemName: "plus.square.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.green)
                        //    .padding()
                            .onTapGesture {
                                addTime()
                                withAnimation(Animation.easeInOut(duration: 0.5).repeatCount(1, autoreverses: true)) {
                                    isAnimating.toggle()
                                }
                            }
                            .offset(y: isAnimating ? -5 : 0)
                        
                        //Button("Add Time", action: { addTime() })
                        
                        
                        Button("Schedule Daily Notifications", action: {
                          //  print("Selected Times for Daily Notifications: \(selectedTimes)")
                           // updateSelectedTimes()
                          //  print("Updated Times for Daily Notifications: \(selectedTimes)")
                            scheduleDailyNotifications()
                        })
                        
                        
                        
                    } else {
                        if scheduleType == "Irregular Schedule" {
                            ForEach(irregularDates.indices, id: \.self) { index in
                                DatePicker(
                                    "Select Date \(index + 1)",
                                    selection: bindingForDatePicker(at: index),
                                    displayedComponents: [.date]
                                )
                                .datePickerStyle(GraphicalDatePickerStyle())
                            }
                        }
                        
                        
                        
                        if !irregularDates.isEmpty {
                            ForEach(irregularDates, id: \.self) { date in
                                Text("Selected Date: \(date.date, formatter: dateFormatter)")
                            }
                        }
                        
                        ForEach(selectedTimes.indices, id: \.self) { index in
                            DatePicker(
                                "Time \(index + 1)",
                                selection: Binding(
                                    get: { self.selectedTimes[index].date },
                                    set: { newDate in
                                        print("Selected new time: \(newDate)")

                                        self.selectedTimes[index].date = newDate
                                    }
                                ),
                                displayedComponents: .hourAndMinute
                            )
                        }
                        .onDelete(perform: deleteTime)
                        
                        
                        Image(systemName: "plus.square.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.green)
                        //    .padding()
                            .onTapGesture {
                                addTime()
                                withAnimation(Animation.easeInOut(duration: 0.5).repeatCount(1, autoreverses: true)) {
                                    isAnimating.toggle()
                                }
                            }
                            .offset(y: isAnimating ? -5 : 0)
                        
                        
                        Button("Schedule Irregular Notifications", action: {
                            print("Selected Dates for Irregular Notifications: \(irregularDates)")
                            print("Selected Times for Irregular Notifications: \(selectedTimes)")
                            scheduleIrregularNotifications()
                        })
                    }
                }
                Button("View Scheduled Notifications") {
                    showScheduledNotifications = true
                }
                NavigationLink(destination: ScheduledNotificationsView(medications: $medications), isActive: $showScheduledNotifications) {
                    EmptyView()
                }
            }
            .navigationBarTitle("Medications")
        }
        .alert(item: $activeAlert) { alertType in
            switch alertType {
            case .dailyScheduleSuccess:
                return Alert(
                    title: Text("Success"),
                    message: Text("Daily notifications scheduled successfully."),
                    dismissButton: .default(Text("OK"))
                )
            case .irregularScheduleSuccess:
                return Alert(
                    title: Text("Success"),
                    message: Text("Irregular notifications scheduled successfully."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .onAppear {
            print("Loading medications")
            loadMedications()
        }
        
        
        // Additional view modifiers and functionality
    }
    
    private func deleteTime(at offsets: IndexSet) {
        selectedTimes.remove(atOffsets: offsets)
    }
    
    private func addTime() {
        selectedTimes.append(AppModels.NotificationTime(date: Date()))
    }
    
    private func scheduleDailyNotifications() {
        // Create a medication record
        let medicationRecord = createMedicationRecord()

        // Request notification permissions
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted, error == nil else {
                // Handle error or denial of permission
                return
            }

            // Schedule notifications for each time in the medication record's daily times
            medicationRecord.dailyTimes?.forEach { time in
                let identifier = self.scheduleNotification(for: time, with: notificationCenter)
                time.identifier = identifier // Update the identifier of the time
            }

            // Append the new medication record to the medications array and save
            DispatchQueue.main.async {
                self.medications.append(medicationRecord)
                self.saveMedications()
            }
        }
    }

    private func scheduleNotification(for time: AppModels.NotificationTime, with notificationCenter: UNUserNotificationCenter) -> String {
        let identifier =  time.timeId.uuidString

        let content = UNMutableNotificationContent()
        content.title = "Medication Reminder"
        content.body = "Time to take your medication: \(self.medicationName), \(self.dosage)"
        content.sound = UNNotificationSound.default

        let triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: time.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Added notification request with ID: \(time.identifier)")

            }
        }

        return identifier
    }



    private func createMedicationRecord() -> AppModels.DogMedicationRecord {
        let medicationName = self.medicationName
        let dosage = self.dosage
        let scheduleType = self.scheduleType // Use the state variable
        let durationInWeeks = self.durationInWeeks

        var allNotificationTimes = [AppModels.NotificationTime]()

        // Generate daily times for each selected time
        for selectedTime in selectedTimes {
            let dailyTimes = createDailyTimes(startingFrom: Date(), for: durationInWeeks ?? 0, at: selectedTime.date)
            allNotificationTimes.append(contentsOf: dailyTimes)
        }

        return AppModels.DogMedicationRecord(
            medicationName: medicationName,
            dosage: dosage,
            scheduleType: scheduleType,
            durationInWeeks: durationInWeeks,
            dailyTimes: allNotificationTimes, // Pass the generated daily times here
            irregularTimes: nil
        )
    }



    private func createDailyTimes(startingFrom startDate: Date, for durationInWeeks: Int, at time: Date) -> [AppModels.NotificationTime] {
        var times = [AppModels.NotificationTime]()
        let calendar = Calendar.current
        let numberOfDays = durationInWeeks * 7

        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)

        for day in 0..<numberOfDays {
            if let dayDate = calendar.date(byAdding: .day, value: day, to: startDate) {
                var dateTimeComponents = calendar.dateComponents([.year, .month, .day], from: dayDate)
                dateTimeComponents.hour = timeComponents.hour
                dateTimeComponents.minute = timeComponents.minute

                if let dateTime = calendar.date(from: dateTimeComponents) {
                    let notificationTime = AppModels.NotificationTime(date: dateTime)
                    times.append(notificationTime)
                }
            }
        }

        return times
    }





    private func scheduleIrregularNotifications() {
        print("Starting to schedule irregular notifications")

        // Adding medication
        print("Adding medication")
        addMedication()

        // Saving medication
        print("Saving medications")
        saveMedications()

        let notificationCenter = UNUserNotificationCenter.current()

        // Request permission to send notifications
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted for notifications. Proceeding to schedule irregular notifications.")
                // Schedule notifications if permission is granted
                self.scheduleIrregularNotifications(notificationCenter: notificationCenter)
                
                DispatchQueue.main.async {
                    print("Setting showingIrregularScheduleSuccessAlert to true")
                    self.activeAlert = .irregularScheduleSuccess
                }
            } else if let error = error {
                // Handle the error case
                print("Error requesting notification authorization: \(error)")
            } else {
                print("Notification permission denied")
            }
        }
    }
    private func scheduleIrregularNotifications(notificationCenter: UNUserNotificationCenter) {
        print("Starting to schedule irregular notifications")

        let content = UNMutableNotificationContent()
        content.title = "Medication Reminder"
        content.body = "Time to take your medication: \(medicationName), \(dosage)"
        content.sound = UNNotificationSound.default

        // Assuming irregularDates and selectedTimes have the same count and corresponding indices
        for (index, dateNotificationTime) in irregularDates.enumerated() {
            guard index < selectedTimes.count,
                  let combinedDateTime = combineDateAndTime(date: dateNotificationTime.date, time: selectedTimes[index].date) else {
                continue // Skip if the date and time cannot be combined
            }

            let notificationIdentifier = UUID().uuidString
            let triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: combinedDateTime)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            notificationCenter.add(request) { error in
                if let error = error {
                    print("Error scheduling irregular notification: \(error)")
                } else {
                    print("Irregular notification scheduled successfully with identifier \(notificationIdentifier)")
                }
            }

            // Update the medication record with the new notification time
            let updatedNotificationTime = AppModels.NotificationTime(date: combinedDateTime, identifier: notificationIdentifier)
            if let lastMedicationIndex = medications.indices.last {
                if index < (medications[lastMedicationIndex].irregularTimes?.count ?? 0) {
                    medications[lastMedicationIndex].irregularTimes?[index] = updatedNotificationTime
                } else {
                    medications[lastMedicationIndex].irregularTimes?.append(updatedNotificationTime)
                }
                print("Updated irregularTimes: \(medications[lastMedicationIndex].irregularTimes)")
            }
        }

        resetForm()
        saveMedications() // Save after updating all identifiers
    }


    private func combineDateAndTime(date: Date, time: Date) -> Date? {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        return calendar.date(from: DateComponents(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: timeComponents.hour, minute: timeComponents.minute))
    }


    private func addMedication() {
        var newMedication: AppModels.DogMedicationRecord
        
        if scheduleType == "Daily" {
            if let specificTime = selectedTimes.first?.date  {
                // specificTime is unwrapped safely here
                newMedication = AppModels.DogMedicationRecord(
                    medicationName: medicationName,
                    dosage: dosage,
                    scheduleType: scheduleType,
                    durationInWeeks: durationInWeeks,
                    dailyTimes: createDailyTimes(startingFrom: Date(), for: durationInWeeks, at: specificTime),
                    irregularTimes: nil
                )
            } else {
                // Handle the case where specificTime is nil
                // For example, you can use the current date as a fallback
                newMedication = AppModels.DogMedicationRecord(
                    medicationName: medicationName,
                    dosage: dosage,
                    scheduleType: scheduleType,
                    durationInWeeks: durationInWeeks,
                    dailyTimes: createDailyTimes(startingFrom: Date(), for: durationInWeeks, at: Date()),
                    irregularTimes: nil
                )
            }
        } else {
            // Irregular schedule
            newMedication = AppModels.DogMedicationRecord(
                medicationName: medicationName,
                dosage: dosage,
                scheduleType: scheduleType,
                durationInWeeks: nil,
                dailyTimes: nil,
                irregularTimes: selectedTimes // Passing selectedTimes directly
            )
        }
        medications.append(newMedication)
        print("Added new medication: \(medicationName)")
    }

    private func saveMedications() {
        print("Saving medications: \(medications)")

        do {
            let encoded = try JSONEncoder().encode(medications)
            UserDefaults.standard.set(encoded, forKey: "SavedMedications")
            print("Successfully saved medications.")
            if let savedData = UserDefaults.standard.data(forKey: "SavedMedications") {
                print("Data written to UserDefaults.")
            } else {
                print("Failed to write data to UserDefaults.")
            }
            
        } catch {
            print("Error saving medications: \(error)")
        }
    }


    private func loadMedications() {
        if let savedItems = UserDefaults.standard.data(forKey: "SavedMedications") {
            do {
                let decodedItems = try JSONDecoder().decode([AppModels.DogMedicationRecord].self, from: savedItems)
                medications = decodedItems
                print("Loaded medications: \(medications)")
            } catch {
                print("Error loading medications: \(error)")
            }
        } else {
            print("No saved medications data found.")
        }
    }

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
    
    private func resetForm() {
        medicationName = ""
        dosage = ""
        scheduleType = "Daily" // or your default value
        durationInWeeks = 1 // or your default value
        selectedTimes = [AppModels.NotificationTime(date: Date())]
        irregularDates = [AppModels.NotificationTime(date: Date())]
    }
    
    // Custom ViewModifier for centering a button
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



